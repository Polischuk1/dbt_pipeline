{% macro learn_variables()%}

    {% set name = "Olha" %}
    {{log("Hello, " ~ name, info = True)}}

    {{log ("Hello dbt user " ~ var("user_name"), info=True )}}

{% endmacro %}