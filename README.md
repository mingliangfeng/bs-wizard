# bs-wizard

jQuery wizard plugin based on Bootstrap.

Inspired by [acc-wizard](https://github.com/sathomas/acc-wizard), this wizard is different from acc-wizard in a few ways:

1. Source is CoffeeScript;
1. Not based on hash when move forward and backward;
1. Not Bootstrap accordion-based;
1. More events and utilize public methods.


This plugin also includes the appropriate CSS which is borrowed from acc-wizard. To initialize wizard:

    $(function() {
    	$(".bs-wizard").bs_wizard();
    });
