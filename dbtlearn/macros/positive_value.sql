{% test positive_value(model,column_name)%}
select * from {{model}} 
where 1 > {{column_name}}
{% endtest %}