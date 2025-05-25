# waiting for new version patching this issue to reenable kas:
# https://gitlab.com/gitlab-org/gitlab/-/issues/543036

docker volume create $GITLAB18EE_DATA
docker volume create $GITLAB18EE_CONF
# create gitlab rb
#docker run -v $GITLAB18EE_CONF:/etc/gitlab busybox touch /etc/gitlab/gitlab.rb

read -r -d '' OMNIBUS_CFG <<EOF
external_url 'http://localhost';\
gitlab_rails['gitlab_shell_ssh_port'] = ${GITLAB18EE_PORT_SSH};\
gitlab_pages['enable'] = true;\
gitlab_pages['enable_disk'] = true;\
pages_nginx['enable'] = true;\
gitlab_rails['pages_path'] = '/var/opt/gitlab/gitlab-rails/shared/pages';\
gitlab_pages['external_http'] = [];\
gitlab_pages['external_https'] = [];\
gitlab_rails['registry_enabled']  = true;\
gitlab_rails['registry_host']     = 'localhost';\
gitlab_rails['registry_port']     = '${GITLAB18EE_PORT_REGISTRY}';\
gitlab_rails['registry_path']     = '/var/opt/gitlab/gitlab-rails/shared/registry';\
gitlab_rails['packages_enabled']  = true;\
gitlab_rails['packages_storage_path'] = '/var/opt/gitlab/gitlab-rails/shared/packages';\
gitlab_rails['initial_root_password'] = '${GITLAB18EE_ADMINPASS}';\
package['modify_kernel_parameters'] = false;\
gitlab_kas['enable'] = false;
EOF

OMNIBUS_CFG_SINGLE=$(printf '%s' "$OMNIBUS_CFG" | tr '\n' ' ')

echo "==="
echo "OMNIBUS_CFG_SINGLE:"
echo $OMNIBUS_CFG_SINGLE

#echo "$(pwd)/default-config/gitlab-kas"
# /var/opt/gitlab/gitlab-kas/gitlab-kas-config.yml
#docker run --rm \
#  -v "$(pwd)/default-config/gitlab-kas":/from:ro \
#  -v "$GITLAB18EE_CONF":/gitlab-kas \
#  alpine sh -c 'set -e && cp -a /from/. "/gitlab-kas"'

docker run -d\
 -p $GITLAB18EE_PORT_RAILS:80\
 -p $GITLAB18EE_PORT_SSH:22\
 -p $GITLAB18EE_PORT_PAGES:8080\
 --name $GITLAB18EE_NAME\
 --restart=always\
 -v $GITLAB18EE_CONF:/etc/gitlab\
 -v $GITLAB18EE_DATA:/var/opt/gitlab\
 --shm-size 4096m \
 --env "GITLAB_OMNIBUS_CONFIG=$OMNIBUS_CFG_SINGLE" \
 --env "GITLAB_ROOT_PASSWORD=$GITLAB18EE_ADMINPASS" \
 $GITLAB18EE_IMAG:$GITLAB18EE_VERS
