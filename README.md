# bs-wizard

jQuery wizard plugin based on Bootstrap.

Inspired by [acc-wizard](https://github.com/sathomas/acc-wizard), this wizard is different from acc-wizard in a few ways:

1. Source code is CoffeeScript;
1. Not based on hash when move forward and backward in wizard;
1. Not based on Bootstrap accordion;
1. More events and utilize public methods.

This plugin also includes a beautiful CSS file which is borrowed from acc-wizard, but this is absolutely optional, you can provide your own css style.

To initialize the wizard:

    $(function() {
    	$(".bs-wizard").bs_wizard();
    });

Check live demo [here](http://mingliangfeng.me/github%20project/2013/08/02/bs-wizard-demo/), and a more sophisticated demo [here](http://mingliangfeng.me/github%20project/2013/08/23/sophisticated-bs-wizard-demo/).

## Options

The plugin accepts options as a single object argument. Supported options are:

* **currentStep** current step to show, default to 1, the first step 
* **addButtons** add next/prev buttons to panels (default: true)
* **sidebar** selector for task sidebar (default: ".bs-wizard-sidebar")
* **activeClass** class to indicate the active task in sidebar (default: "bs-wizard-active")
* **completedClass** class to indicate task is complete (default: "bs-wizard-completed")
* **todoClass** class to indicate task is still pending (default: "bs-wizard-todo")
* **stepClass** class for step buttons within panels (default: "bs-wizard-step")
* **nextText** text for next button (default: "Next Step")
* **backText** text for back button (default: "Go Back")
* **nextType** HTML input type for next button (default: "submit")
* **backType** HTML input type for back button (default: "reset")
* **nextClasses** class(es) for next button (default: "btn btn-primary")
* **backClasses** class(es) for back button (default: "btn")
* **beforeNext** function to call before going to next step, return true to proceed to the next step; others to stop. e.g. used for validation
* **onNext** function to call on next step
* **beforeBack** function to call before going to previous step, return true to proceed to the next step; others to stop
* **onBack** function to call on back up
* **onInit** a chance to hook initialization
* **onDestroy** a chance to hook destruction


## Public Methods

Public methods could be retrieved:
    
    $('#last-step-back-button').click($(".bs-wizard").bs_wizard('go_prev'))

or called by supplying arguments:

    $(".bs-wizard").bs_wizard('show_step', 1)

Public methods list:

* **option** Get/set a plugin option: $('#el').bs_wizard('option', 'addButtons') and $('#el').bs_wizard('option', 'addButtons', true)
* **destroy** Destroy plugin: $('#el').bs_wizard('destroy')()
* **go_next** Go to next step
* **go_prev** Go back to previous step
* **show_step** Go to wizard step, starting from 1

## License

bs-wizard is licensed under the MIT license.
