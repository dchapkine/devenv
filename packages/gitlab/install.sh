# waiting for new version patching this issue to reenable kas:
# https://gitlab.com/gitlab-org/gitlab/-/issues/543036

docker volume create $GITLAB_DATA
docker volume create $GITLAB_CONF
# create gitlab rb
#docker run -v $GITLAB_CONF:/etc/gitlab busybox touch /etc/gitlab/gitlab.rb

read -r -d '' OMNIBUS_CFG <<EOF
external_url 'http://localhost:${GITLAB_PORT_RAILS}';
gitlab_rails['gitlab_shell_ssh_port'] = ${GITLAB_PORT_SSH};
gitlab_pages['enable'] = true;
gitlab_pages['enable_disk'] = true;
pages_nginx['enable'] = true;
gitlab_rails['pages_path'] = "/var/opt/gitlab/gitlab-rails/shared/pages";
gitlab_pages['external_http'] = [];
gitlab_pages['external_https'] = [];
gitlab_rails['registry_enabled']  = true;
gitlab_rails['registry_host']     = "localhost";
gitlab_rails['registry_port']     = "${GITLAB_PORT_REGISTRY}";
gitlab_rails['registry_path']     = "/var/opt/gitlab/gitlab-rails/shared/registry";
gitlab_rails['packages_enabled']  = true;
gitlab_rails['packages_storage_path'] = "/var/opt/gitlab/gitlab-rails/shared/packages";
gitlab_rails['initial_root_password'] = "${GITLAB_ADMINPASS}";
package['modify_kernel_parameters'] = false;
gitlab_kas['enable'] = false;
EOF

OMNIBUS_CFG_SINGLE=$(printf '%s' "$OMNIBUS_CFG" | tr '\n' ' ')

#echo "$(pwd)/default-config/gitlab-kas"
# /var/opt/gitlab/gitlab-kas/gitlab-kas-config.yml
#docker run --rm \
#  -v "$(pwd)/default-config/gitlab-kas":/from:ro \
#  -v "$GITLAB_CONF":/gitlab-kas \
#  alpine sh -c 'set -e && cp -a /from/. "/gitlab-kas"'

docker run -d\
 -p $GITLAB_PORT_RAILS:80\
 -p $GITLAB_PORT_SSH:22\
 -p $GITLAB_PORT_PAGES:8080\
 --name $GITLAB_NAME\
 --restart=always\
 -v $GITLAB_CONF:/etc/gitlab\
 -v $GITLAB_DATA:/var/opt/gitlab\
 --shm-size 4096m \
 --env "GITLAB_OMNIBUS_CONFIG=$OMNIBUS_CFG_SINGLE" \
 --env "GITLAB_ROOT_PASSWORD=$GITLAB_ADMINPASS" \
 $GITLAB_IMAG:$GITLAB_VERS
