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


Check live demo [here](http://mingliangfeng.me/github%20project/2013/08/02/bs-wizard-demo/).
