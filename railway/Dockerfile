# Imagen ERPNext + HRMS + rrhh_seleccion para Railway (contexto = raíz del repo)
ARG FRAPPE_BRANCH=version-16
ARG FRAPPE_IMAGE_PREFIX=frappe

FROM ${FRAPPE_IMAGE_PREFIX}/build:${FRAPPE_BRANCH} AS builder

ARG FRAPPE_BRANCH=version-16
ARG FRAPPE_PATH=https://github.com/frappe/frappe

USER frappe

COPY apps.json /opt/frappe/apps.json

RUN bench init \
    --apps_path=/opt/frappe/apps.json \
    --frappe-branch=${FRAPPE_BRANCH} \
    --frappe-path=${FRAPPE_PATH} \
    --no-procfile \
    --no-backups \
    --skip-redis-config-generation \
    --verbose \
    /home/frappe/frappe-bench && \
  cd /home/frappe/frappe-bench && \
  echo "{}" > sites/common_site_config.json && \
  find apps -mindepth 1 -path "*/.git" | xargs rm -fr

COPY --chown=frappe:frappe resources/rrhh_seleccion /home/frappe/frappe-bench/apps/rrhh_seleccion

RUN cd /home/frappe/frappe-bench && \
  ./env/bin/pip install -q -e ./apps/rrhh_seleccion && \
  bench build --app rrhh_seleccion

FROM ${FRAPPE_IMAGE_PREFIX}/base:${FRAPPE_BRANCH} AS backend

USER frappe

COPY --from=builder --chown=frappe:frappe /home/frappe/frappe-bench /home/frappe/frappe-bench

WORKDIR /home/frappe/frappe-bench

RUN cp -r /home/frappe/frappe-bench/sites/assets /home/frappe/frappe-bench/assets && \
  rm -rf /home/frappe/frappe-bench/sites/assets

VOLUME ["/home/frappe/frappe-bench/sites"]

USER root
COPY resources/core/nginx/nginx-template.conf /templates/nginx/frappe.conf.template
COPY resources/core/nginx/nginx-entrypoint.sh /usr/local/bin/nginx-entrypoint.sh
COPY resources/core/nginx/security_headers.conf /etc/nginx/snippets/security_headers.conf
RUN chmod 644 /templates/nginx/frappe.conf.template && chmod 755 /usr/local/bin/nginx-entrypoint.sh
COPY resources/core/main-entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod 755 /usr/local/bin/entrypoint.sh
COPY resources/core/start.sh /usr/local/bin/start.sh
RUN chmod 755 /usr/local/bin/start.sh
COPY railway/scripts/init-site.sh /usr/local/bin/init-site.sh
COPY railway/scripts/start-frontend.sh /usr/local/bin/start-frontend.sh
RUN chmod 755 /usr/local/bin/init-site.sh /usr/local/bin/start-frontend.sh

# Root entrypoint ajusta permisos de volúmenes Railway y ejecuta como frappe
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["start.sh"]
