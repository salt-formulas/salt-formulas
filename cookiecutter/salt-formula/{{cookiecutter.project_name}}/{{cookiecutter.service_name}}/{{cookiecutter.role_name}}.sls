{{ '{%-' }} from "{{cookiecutter.service_name}}/map.jinja" import {{cookiecutter.role_name}} with context {{ '%}' }}
{{ '{%-' }} if {{cookiecutter.role_name}}.enabled {{ '%}' }}

{{ '{%-' }} endif {{ '%}' }}
