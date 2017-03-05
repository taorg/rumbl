defmodule Rumbl.AutocompleteControler do
  use Rumbl.Web, :controller 
  @moduledoc false

  def index(conn, _params) do
response = """ 
{"status":true,"error":null,"data":{"user":[{"id":4152589,"username":"TheTechnoMan","avatar":"https:\/\/avatars2.githubusercontent.com\/u\/4152589"},{"id":748137,"username":"juliocastrop","avatar":"https:\/\/avatars3.githubusercontent.com\/u\/748137"},{"id":619726,"username":"cfreear","avatar":"https:\/\/avatars0.githubusercontent.com\/u\/619726"},{"id":906237,"username":"nilovna","avatar":"https:\/\/avatars2.githubusercontent.com\/u\/906237"},{"id":612578,"username":"Thiago Talma","avatar":"https:\/\/avatars2.githubusercontent.com\/u\/612578"},{"id":1723363,"username":"dennisgaudenzi","avatar":"https:\/\/avatars2.githubusercontent.com\/u\/1723363"},{"id":2757851,"username":"pradeshc","avatar":"https:\/\/avatars2.githubusercontent.com\/u\/2757851"}],"project":[{"id":1,"project":"jQuery Typeahead","image":"http:\/\/www.runningcoder.org\/assets\/jquerytypeahead\/img\/jquerytypeahead-preview.jpg","version":"1.7.0","demo":10,"option":23,"callback":6},{"id":2,"project":"jQuery Validation","image":"http:\/\/www.runningcoder.org\/assets\/jqueryvalidation\/img\/jqueryvalidation-preview.jpg","version":"1.4.0","demo":11,"option":14,"callback":8}]}}
"""

     send_resp(conn, 200, response)
  end
end
