external_url 'https://gitlab.{{domain}}'
nginx['listen_port'] = 80
nginx['listen_https'] = false
gitlab_rails['initial_root_password'] = '{{gitlab_pass}}'
