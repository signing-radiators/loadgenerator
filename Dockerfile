FROM python:3-slim as base

FROM base as builder

RUN apt-get -qq update \
    && apt-get install -y --no-install-recommends \
        g++

COPY requirements.txt .

RUN pip install --install-option="--prefix=/install" -r requirements.txt

FROM base
COPY --from=builder /install /usr/local

COPY . .
ENV FRONTEND_ADDR frontend.default.svc.cluster.local
RUN chmod +x ./loadgen.sh
ENTRYPOINT ./loadgen.sh
