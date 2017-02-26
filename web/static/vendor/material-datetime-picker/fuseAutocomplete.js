/**************************
 * Auto complete plugin  *
 *************************/
(function ($) {
$.fn.fuseautocomplete = function (options) {
  // Defaults
  var defaults = {
    data: {},
    limit: Infinity,
    onAutocomplete: null
  };

  options = $.extend(defaults, options);

  return this.each(function() {
    var $input = $(this);
    var data = options.data,
        fuseOptions = options.fuseOptions,
        dataIdentifierFn = options.dataIdentifierFn,
        renderItemFn = options.renderItemFn,
        fuse = new Fuse(data, fuseOptions),
        count = 0,
        activeIndex = 0,
        oldVal,
        $inputDiv = $input.closest('.input-field'); // Div to append on

    // Check if data isn't empty
    if (!$.isEmptyObject(data)) {
      var $autocomplete = $('<ul class="autocomplete-content dropdown-content"></ul>');
      var $oldAutocomplete;

      // Append autocomplete element.
      // Prevent double structure init.
      if ($inputDiv.length) {
        $oldAutocomplete = $inputDiv.children('.autocomplete-content.dropdown-content').first();
        if (!$oldAutocomplete.length) {
          $inputDiv.append($autocomplete); // Set ul in body
        }
      } else {
        $oldAutocomplete = $input.next('.autocomplete-content.dropdown-content');
        if (!$oldAutocomplete.length) {
          $input.after($autocomplete);
        }
      }
      if ($oldAutocomplete.length) {
        $autocomplete = $oldAutocomplete;
      }

      // Highlight partial match.
      var highlight = function(string, $el) {
        var img = $el.find('img');
        var matchStart = $el.text().toLowerCase().indexOf("" + string.toLowerCase() + ""),
            matchEnd = matchStart + string.length - 1,
            beforeMatch = $el.text().slice(0, matchStart),
            matchText = $el.text().slice(matchStart, matchEnd + 1),
            afterMatch = $el.text().slice(matchEnd + 1);
        $el.html("<span>" + beforeMatch + "<span class='highlight'>" + matchText + "</span>" + afterMatch + "</span>");
        if (img.length) {
          $el.prepend(img);
        }
      };

      // Reset current element position
      var resetCurrentElement = function() {
        activeIndex = 0;
        $autocomplete.find('.active').removeClass('active');
      }

      // Perform search
      $input.off('keyup.autocomplete').on('keyup.autocomplete', function (e) {
        // Reset count.
        count = 0;

        // Don't capture enter or arrow key usage.
        if (e.which === 13 ||
            e.which === 38 ||
            e.which === 40) {
          return;
        }

        var val = $input.val().toLowerCase();

        // Check if the input isn't empty
        if (oldVal !== val) {
          $autocomplete.empty();
          resetCurrentElement();

          if (val !== '') {
            fdata = fuse.search(val);
            for(var key in fdata) {
                if (count >= options.limit) {
                  break;
                }
                var autocompleteOption = $('<li></li>');
                autocompleteOption.data("dataSelectionId",dataIdentifierFn(fdata[key]));
                if (!!renderItemFn) {//!!fuseOptions.key
                    autocompleteOption.append(renderItemFn(fdata[key]));
                } else {
                  autocompleteOption.append('<span>'+ fdata[key] +'</span>');
                }

                $autocomplete.append(autocompleteOption);
                highlight(val, autocompleteOption);
                count++;
            }
          }
        }

        // Update oldVal
        oldVal = val;
      });

      $input.off('keydown.autocomplete').on('keydown.autocomplete', function (e) {
        // Arrow keys and enter key usage
        var keyCode = e.which,
            liElement,
            numItems = $autocomplete.children('li').length,
            $active = $autocomplete.children('.active').first();

        // select element on Enter
        if (keyCode === 13) {
          liElement = $autocomplete.children('li').eq(activeIndex);
          if (liElement.length) {
            liElement.click();
            e.preventDefault();
          }
          return;
        }

        // Capture up and down key
        if ( keyCode === 38 || keyCode === 40 ) {
          e.preventDefault();

          if (keyCode === 38 &&
              activeIndex > 0) {
            activeIndex--;
          }

          if (keyCode === 40 &&
              activeIndex < (numItems - 1) &&
              $active.length) {
            activeIndex++;
          }

          $active.removeClass('active');
          $autocomplete.children('li').eq(activeIndex).addClass('active');
        }
      });

      // Set input value
      $autocomplete.on('click', 'li', function () {
        var text = $(this).text().trim();
        $input.val(text);
        $input.trigger('change');
        $input.data("data-id", $(this).data("dataSelectionId"));
        $autocomplete.empty();
        resetCurrentElement();

        // Handle onAutocomplete callback.
        if (typeof(options.onAutocomplete) === "function") {
          options.onAutocomplete.call(this, text);
        }
      });
    }
  });
};

}( jQuery ));
