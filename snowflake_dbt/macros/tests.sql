{% macro test_test_positive(model, col) %}
SELECT *
FROM {{ model }}
WHERE {{ col }} < 0
{% endmacro %}

{% macro test_test_product(model, colA, colB, colC) %}
SELECT *
FROM {{ model }}
WHERE {{ colA }} * {{ colB }} <> {{ colC }}
{% endmacro %}