function confirmClearDatePlugin(pluginConfig) {
	const defaultConfig = {
		confirmIcon: "<svg version='1.1' xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' width='17' height='17' viewBox='0 0 17 17'> <g> </g> <path d='M15.418 1.774l-8.833 13.485-4.918-4.386 0.666-0.746 4.051 3.614 8.198-12.515 0.836 0.548z' fill='#000000' /> </svg>",
		confirmText: "OK ",
		showAlways: false,
        cancelText: "CLEAR",
        cancelIcon: "<svg version='1.1' xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink'  height='17' width='17' viewBox='0 0 17 17'> <g> </g> ><path d='M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z'/><path d='M0 0h24v24H0z' fill='none'/></svg>"
	};

	const config = Object.assign({}, defaultConfig, pluginConfig || {});

	return function(fp) {


        fp.cancelContainer = fp._createElement("div", "flatpickr-cancel", config.cancelText);
		fp.cancelContainer.innerHTML += config.cancelIcon;

		fp.confirmContainer = fp._createElement("div", "flatpickr-confirm", config.confirmText);
		fp.confirmContainer.innerHTML += config.confirmIcon;

		fp.cancelContainer.addEventListener("click", fp.clear )
        fp.confirmContainer.addEventListener("click", fp.close);
		const hooks = {
			onReady () {
				fp.calendarContainer.appendChild(fp.confirmContainer);
                fp.calendarContainer.appendChild(fp.cancelContainer);
			}
		};

		if (config.showAlways){
			fp.confirmContainer.classList.add("visible");
            fp.cancelContainer.classList.add("visible");
            }
		else
			hooks.onChange = function(dateObj, dateStr) {
				if(dateStr && !fp.config.inline){
                        fp.cancelContainer.classList.add("visible");
					return fp.confirmContainer.classList.add("visible");
                }
				fp.confirmContainer.classList.remove("visible");
                fp.cancelContainer.classList.remove("visible");
			}

		return hooks;
	}
}

if (typeof module !== "undefined")
	module.exports = confirmClearDatePlugin;
