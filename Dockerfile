
ARG POSTGRES_VERSION=11

FROM mdillon/postgis:${POSTGRES_VERSION}-alpine

ARG PGSIMILARITY_VERSION=master
ARG PGSIMILARITY_REPOSITORY=eulerto/pg_similarity

RUN  set -ex \
  && SRCDIR=/usr/src/pg_similarity \
  && apk add --no-cache --virtual .deps curl tar gcc make musl-dev\
  && mkdir -p "${SRCDIR}" \
  && curl -sL "https://github.com/${PGSIMILARITY_REPOSITORY}/archive/${PGSIMILARITY_VERSION}.tar.gz" \
   | tar -xz --strip-components 1 -C "${SRCDIR}" \
  && ( \
    cd "${SRCDIR}" \
    && USE_PGXS=1 make \
    && USE_PGXS=1 make install \
  ) \
  && rm -rf "${SRCDIR}" \
  && apk del .deps

COPY ./initdb-pg_similarity.sh /docker-entrypoint-initdb.d/pg_similarity.sh
