//= require jquery
//= require jquery_ujs
if (typeof window.GOVUK == 'undefined') GOVUK = {};
GOVUK.factCave = (function(){
  var $dataTypeEl = $("#fact_data_type");
  var showDataTypeOptions = function(){
    var dataType = $dataTypeEl.val();
    var formatOpts = $("." + dataType);
    if (formatOpts){
      $('.format-options').hide();
      formatOpts.show();
    }
  }
  $dataTypeEl.on("change", showDataTypeOptions);
  showDataTypeOptions();
})();
