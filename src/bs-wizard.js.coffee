# Reference jQuery
$ = jQuery

"use strict"

pluginName = "bs_wizard"
data_pluginName = "plugin_#{pluginName}"
$.fn[pluginName] = (options) ->
  # If the first parameter is a string, treat this as a call to
  # a public method. The first parameter is the method name and
  # following parameters are arguments for the method.  
  if typeof arguments[0] is "string"
    methodName = arguments[0]
    args = Array::slice.call(arguments, 1)
    returnVals =[]
    @each ->
      # Check if the element has a plugin instance, and if the requested public method exists
      plugin_instance = $.data(this, data_pluginName)
      if plugin_instance and typeof plugin_instance[methodName] is "function"
        if args.length > 0 
          # if arguments are supplied, call the method with the supplied arguments
          returnVals.push plugin_instance[methodName].apply(this, args)
        else
          # if no argument is supplied, return the function, user can invoke it when required, 
          # convienient for binding public method with event
          returnVals.push plugin_instance[methodName]
      else
        throw new Error("Method #{methodName} does not exist on jQuery. #{pluginName}")

    return returnVals[0] if returnVals.length = 1
    
    returnVals

  # If the first parameter is an object (options), or was omitted,
  # instantiate a new instance of the plugin.
  else if typeof options is "object" or not options
    @each ->
      # Only allow the plugin to be instantiated once.
      # Pass options to Plugin constructor, and store Plugin
      # instance in the element's jQuery data object.
      $.data this, data_pluginName, new Plugin(this, options) unless $.data(this, data_pluginName)

# Default plugin options.
# Options can be overwritten when initializing plugin, by passing an object literal, 
# or after initialization: $('#el').bs_wazard('option', 'key', value);
$.fn[pluginName].defaults =
  currentStep: 1                               # current step to show, default to 1, the first step 
  addButtons: true                             # add next/prev buttons to panels
  sidebar: ".bs-wizard-sidebar"                # selector for task sidebar
  activeClass: "bs-wizard-active"              # class to indicate the active task in sidebar
  completedClass: "bs-wizard-completed"        # class to indicate task is complete
  todoClass: "bs-wizard-todo"                  # class to indicate task is still pending
  stepClass: "bs-wizard-step"                  # class for step buttons within panels
  nextText: "Next Step"                        # text for next button
  backText: "Go Back"                          # text for back button
  nextType: "submit"                           # HTML input type for next button
  backType: "reset"                            # HTML input type for back button
  nextClasses: "btn btn-primary"               # class(es) for next button
  backClasses: "btn btn-default"               # class(es) for back button
  beforeNext: -> true                          # hook before going to next step, e.g. used for validation
  onNext: -> true                              # function to call on next step
  beforeBack: -> true                          # hook before going to previous step
  onBack: -> true                              # function to call on back up
  onInit: -> true                              # a chance to hook initialization
  onDestroy: -> true                           # a chance to hook destruction

# Plugin implementation
Plugin = (element, options) ->

  # Initialize plugin
  init = ->
    if options.addButtons
      add_buttons()
      $("." + options.stepClass, $el).children("button[type='" + options.nextType + "']").click go_next
      $("." + options.stepClass, $el).children("button[type='" + options.backType + "']").click go_prev

    active_step()
    
    hook "onInit"

  # Add back and next buttons
  add_buttons = ->
    nextOnly = $("<div/>", class: options.stepClass).append($("<button/>",
      class: options.nextClasses
      type: options.nextType
      text: options.nextText
    ))
    nextBack = $("<div/>", class: options.stepClass).append($("<button/>",
      class: options.backClasses
      type: options.backType
      text: options.backText
    )).append(" ").append($("<button/>",
      class: options.nextClasses
      type: options.nextType
      text: options.nextText
    ))
    
    # Grab all the <form> elements in the steps stack
    # and count them.
    all_steps = $(".bs-step .bs-step-inner form", $el)
    # if no forms in .bs-step-inner, a single form may wrap all steps
    all_steps = $(".bs-step .bs-step-inner", $el) if all_steps.length == 0    
    # We deliberately skip the last form element because
    # that should be the confirm button for the whole page
    last = all_steps.length - 1

    ix = 0
    while ix < last
      if ix is 0
        $(all_steps[0]).append nextOnly
      else
        $(all_steps[ix]).append $(nextBack).clone()
      ix++
  
  # Make one step active
  active_step = (step = null) ->
    all_steps = $(".bs-step", $el)
    if step == null
      step = options.currentStep
    else
      options.currentStep = step
    if step >= 1 and step <= all_steps.length
      step_index = step - 1
      all_steps.hide()
      $(all_steps[step_index]).show()

      $(options.sidebar, $el).children("li.#{options.todoClass}").removeClass options.activeClass
      $($(options.sidebar, $el).children("li.#{options.todoClass}")[step_index]).addClass options.activeClass

  # Go to next step, exposed as public
  # Can be retrived by $('#el').bs_wizard('go_next')
  go_next = (ev)->
    ev.preventDefault() if ev?
    panel = $(this).parents(".bs-step-inner")[0]
    return unless panel? and hook("beforeNext", panel)
    $($(options.sidebar, $el).children("li.#{options.todoClass}")[options.currentStep - 1]).addClass options.completedClass

    active_step options.currentStep + 1
    hook "onNext", panel

  # Go back to previous step, exposed as public
  # Can be retrived by $('#el').bs_wizard('go_prev')
  go_prev = (ev)->
    ev.preventDefault() if ev?
    panel = $(this).parents(".bs-step-inner")[0]
    return unless panel? and hook("beforeBack", panel)
    active_step options.currentStep - 1
    hook "onPrev", panel

  # show a step, starting from 1
  show_step = (step)-> active_step(step)

  # Get/set a plugin option.
  # Get usage: $('#el').bs_wizard('option', 'key');
  # Set usage: $('#el').bs_wizard('option', 'key', value);
  option = (key, val) ->
    if val
      options[key] = val
    else
      options[key]
  
  # Destroy plugin.
  # Usage: $('#el').bs_wizard('destroy')();
  destroy = ->
    return unless hook "onDestroy"
    $.data this, data_pluginName, null
  
  # Callback hooks.
  # Usage: In the defaults object specify a callback function:
  # hookName: function() {}
  # Then somewhere in the plugin trigger the callback:
  # hook('hookName');
  hook = (hookName) ->
    if options[hookName]?
      # Call the user defined function.
      # Scope is set to the jQuery element we are operating on.
      fn = options[hookName]
      arguments[0] = el
      fn.apply this, arguments

  el = element
  $el = $(element)
  options = $.extend({}, $.fn[pluginName].defaults, options)
  
  # Initialize the plugin instance.
  init()
  
  # Expose methods of Plugin we wish to be public.
  public_methods =
    option: option
    destroy: destroy
    go_next: go_next
    go_prev: go_prev
    show_step: show_step

  