
var Dynaform = {};

function DynaformType(){
  
  this.name = function(){
    return 'textbox';
  };
  
  this.previewHtml = function(){
    return "<input type=\"text\" value=\"(textbox)\" disabled />";
  };

  this.defaultModel = function(){
    return {type: this.name(), label: ""};
  };
  
  this.edit = function(state){
    state.label = prompt("Please enter label:", state.label);
    if(state.label != '' && state.label != null){
      state.save();
    }
  };
  
  this.add = function(state){
    this.edit(state);
  }
  
  this.confirmDeleteMessage = function(){
    return "Are you sure you want to delete this " + this.name() + "?";
  };
  
  this.confirmDelete = function(){
    return confirm(this.confirmDeleteMessage());
  };
}

(function(){
  var types = [];
  
  Dynaform.addType = function(type){
    types[type.name()] = type;
  };
  
  Dynaform.type = function(name){
    return types[name];
  };
  
  function InputState(model, fn){
    for(var i in model){
      this[i] = model[i];
    }
    this.save = function(){
      out = {};
      for(var i in model){
        out[i] = this[i];
      }
      fn(out);
    }
  }
  
  
  function to_json_string(data){
    if(typeof data == 'number' || typeof data == 'boolean'){
      return data;
    }
    if(typeof data == 'string'){
      return "\"" + data.replace(/\"/, "\\\"") + "\"";
    }
    if(data instanceof Array){
      var items = [];
      for(var i in data){
        items.push(to_json_string(data[i]));
      }
      return "[" + items.join(",") + "]";
    }
    var items = [];
    for(var i in data){
      items.push(to_json_string(i) + ":" + to_json_string(data[i]));
    }
    return "{" + items.join(",") + "}";
  }
  
  function html_escape(data){
    return data.replace(/&/, "&amp;").replace(/</, "&lt;").replace(/>/, "&gt;").replace(/\"/, "&quot;");
  }
  
  function Editor(form_input){
    var that = this;
    var container = $('<div class="dynaform_editor">');
    $(form_input).hide();
    container.insertAfter(form_input);
    
    var model;
    try {model = jQuery.parseJSON($(form_input).val());} catch(e){};
    if(!model){
      model = {inputs: []};
    }
    
    function update(){
      $(container).html("");
      
      var table = $("<table>");
      $(container).append(table);
      
      var inputs = model['inputs'];
      
      if(inputs.length > 0 ){
        table.html("<tr><th>Label</th><th>Preview</th></tr>");
      }
      
      for(var i in inputs){
        var input = inputs[i];
        var row = $("<tr>");
        $(table).append(row);
        

        (function(i){
          
          var cell = $("<td valign=\"top\" class=\"label\">"+html_escape(input.label)+"</td><td class=\"preview\">"+types[input.type].previewHtml()+"</td>");
          $(row).append(cell);
          
          var cell = $("<td valign=\"top\"><a href=\"javascript:;\" class=\"button edit\">Edit</a></td>");
          $(row).append(cell);
          $(cell).find("a").click(function(){
            types[inputs[i].type].edit(new InputState(inputs[i], function(input_model){
              inputs[i] = input_model;
              update();
            }));
          });
          
          var cell = $("<td valign=\"top\"><a href=\"javascript:;\" class=\"button delete\">Delete</a></td>");
          $(row).append(cell);
          $(cell).find("a").click(function(){
            if(types[inputs[i].type].confirmDelete()){
              var new_inputs = [];
              for(var j in inputs){
                if(j != i){
                  new_inputs.push(inputs[j]);
                }
              }
              model['inputs'] = new_inputs;
              update();
            }
          });
          
          var cell = $("<td valign=\"top\"><a href=\"javascript:;\" class=\"button up\">Up</a></td>");
          $(row).append(cell);
          if(i > 0){
            $(cell).find("a").click(function(){
              var current = inputs[i];
              inputs[i] = inputs[i - 1];
              inputs[i - 1] = current;
              update();
            });
          } 
          var cell = $("<td valign=\"top\"><a href=\"javascript:;\"  class=\"button down\">Down</a></td>");
          $(row).append(cell);
          if(i < inputs.length - 1){
            $(cell).find("a").click(function(){
              var current = inputs[i];
              inputs[i] = inputs[i + 1];
              inputs[i + 1] = current;
              update();
            });
          } 
          
        })(parseInt(i));
      }
      
      var row = $("<tr>");
      $(table).append(row);
      var cell = $("<td colspan=\"6\">");
      $(row).append(cell);
      var insert_select = $("<select>");
      $(cell).append(insert_select);
      $(insert_select).append($("<option selected> --- Add --- </option>"));
      for(var i in types){
        var type = types[i];
        $(insert_select).append($("<option value=\""+i+"\">"+i+"</option>"));
      }

      $(insert_select).change(function(){
        var type = $(this).val();
        $(this).val("");
        types[type].add(new InputState(types[type].defaultModel(), function(input_model){
          model.inputs.push(input_model);
          update();
        }));
      });
      
      $(form_input).val(to_json_string(model));
    }
    update();
  }

  $(function(){
    $(".dynaform").each(function(){new Editor(this);});
  });
})();

