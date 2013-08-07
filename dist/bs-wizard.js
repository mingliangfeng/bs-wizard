(function() {
  var $, Plugin, data_pluginName, pluginName;

  $ = jQuery;

  "use strict";

  pluginName = "bs_wizard";

  data_pluginName = "plugin_" + pluginName;

  $.fn[pluginName] = function(options) {
    var args, methodName, returnVals;
    if (typeof arguments[0] === "string") {
      methodName = arguments[0];
      args = Array.prototype.slice.call(arguments, 1);
      returnVals = [];
      this.each(function() {
        var plugin_instance;
        plugin_instance = $.data(this, data_pluginName);
        if (plugin_instance && typeof plugin_instance[methodName] === "function") {
          if (args.length > 0) {
            return returnVals.push(plugin_instance[methodName].apply(this, args));
          } else {
            return returnVals.push(plugin_instance[methodName]);
          }
        } else {
          throw new Error("Method " + methodName + " does not exist on jQuery. " + pluginName);
        }
      });
      if (returnVals.length = 1) {
        return returnVals[0];
      }
      return returnVals;
    } else if (typeof options === "object" || !options) {
      return this.each(function() {
        if (!$.data(this, data_pluginName)) {
          return $.data(this, data_pluginName, new Plugin(this, options));
        }
      });
    }
  };

  $.fn[pluginName].defaults = {
    currentStep: 1,
    addButtons: true,
    sidebar: ".bs-wizard-sidebar",
    activeClass: "bs-wizard-active",
    completedClass: "bs-wizard-completed",
    todoClass: "bs-wizard-todo",
    stepClass: "bs-wizard-step",
    nextText: "Next Step",
    backText: "Go Back",
    nextType: "submit",
    backType: "reset",
    nextClasses: "btn btn-primary",
    backClasses: "btn btn-default",
    beforeNext: function() {
      return true;
    },
    onNext: function() {
      return true;
    },
    beforeBack: function() {
      return true;
    },
    onBack: function() {
      return true;
    },
    onInit: function() {
      return true;
    },
    onDestroy: function() {
      return true;
    }
  };

  Plugin = function(element, options) {
    var $el, active_step, add_buttons, destroy, el, go_next, go_prev, hook, init, option, public_methods, show_step;
    init = function() {
      if (options.addButtons) {
        add_buttons();
        $("." + options.stepClass, $el).children("button[type='" + options.nextType + "']").click(go_next);
        $("." + options.stepClass, $el).children("button[type='" + options.backType + "']").click(go_prev);
      }
      active_step();
      return hook("onInit");
    };
    add_buttons = function() {
      var all_steps, ix, last, nextBack, nextOnly, _results;
      nextOnly = $("<div/>", {
        "class": options.stepClass
      }).append($("<button/>", {
        "class": options.nextClasses,
        type: options.nextType,
        text: options.nextText
      }));
      nextBack = $("<div/>", {
        "class": options.stepClass
      }).append($("<button/>", {
        "class": options.backClasses,
        type: options.backType,
        text: options.backText
      })).append(" ").append($("<button/>", {
        "class": options.nextClasses,
        type: options.nextType,
        text: options.nextText
      }));
      all_steps = $(".bs-step .bs-step-inner form", $el);
      if (all_steps.length === 0) {
        all_steps = $(".bs-step .bs-step-inner", $el);
      }
      last = all_steps.length - 1;
      ix = 0;
      _results = [];
      while (ix < last) {
        if (ix === 0) {
          $(all_steps[0]).append(nextOnly);
        } else {
          $(all_steps[ix]).append($(nextBack).clone());
        }
        _results.push(ix++);
      }
      return _results;
    };
    active_step = function(step) {
      var all_steps, step_index;
      if (step == null) {
        step = null;
      }
      all_steps = $(".bs-step", $el);
      if (step === null) {
        step = options.currentStep;
      } else {
        options.currentStep = step;
      }
      if (step >= 1 && step <= all_steps.length) {
        step_index = step - 1;
        all_steps.hide();
        $(all_steps[step_index]).show();
        $(options.sidebar, $el).children("li." + options.todoClass).removeClass(options.activeClass);
        return $($(options.sidebar, $el).children("li." + options.todoClass)[step_index]).addClass(options.activeClass);
      }
    };
    go_next = function(ev) {
      var panel;
      if (ev != null) {
        ev.preventDefault();
      }
      panel = $(this).parents(".bs-step-inner")[0];
      if (!((panel != null) && hook("beforeNext", panel))) {
        return;
      }
      $($(options.sidebar, $el).children("li." + options.todoClass)[options.currentStep - 1]).addClass(options.completedClass);
      active_step(options.currentStep + 1);
      return hook("onNext", panel);
    };
    go_prev = function(ev) {
      var panel;
      if (ev != null) {
        ev.preventDefault();
      }
      panel = $(this).parents(".bs-step-inner")[0];
      if (!((panel != null) && hook("beforeBack", panel))) {
        return;
      }
      active_step(options.currentStep - 1);
      return hook("onPrev", panel);
    };
    show_step = function(step) {
      return active_step(step);
    };
    option = function(key, val) {
      if (val) {
        return options[key] = val;
      } else {
        return options[key];
      }
    };
    destroy = function() {
      if (!hook("onDestroy")) {
        return;
      }
      return $.data(this, data_pluginName, null);
    };
    hook = function(hookName) {
      var fn;
      if (options[hookName] != null) {
        fn = options[hookName];
        arguments[0] = el;
        return fn.apply(this, arguments);
      }
    };
    el = element;
    $el = $(element);
    options = $.extend({}, $.fn[pluginName].defaults, options);
    init();
    return public_methods = {
      option: option,
      destroy: destroy,
      go_next: go_next,
      go_prev: go_prev,
      show_step: show_step
    };
  };

}).call(this);
