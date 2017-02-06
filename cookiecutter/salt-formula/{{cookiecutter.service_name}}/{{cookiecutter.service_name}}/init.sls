{{ '{%-' }} if pillar.{{cookiecutter.service_name}} is defined {{ '%}' }}
include:
{{ '{%-' }} if pillar.{{cookiecutter.service_name}}.{{cookiecutter.role_name}} is defined {{ '%}' }}
- {{cookiecutter.service_name}}.{{cookiecutter.role_name}}
{{ '{%-' }} endif {{ '%}' }}
{{ '{%-' }} endif {{ '%}' }}
