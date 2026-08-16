# Boomi Functional Integration Tracing

Companion repository for the tutorial **"Boomi Functional Integration Tracing: A Technical Deep Dive"**.

This repo contains the step-by-step Markdown notes, JSON schemas, and Azure API Management policies used to build a functional and technical tracing framework for Boomi integrations. The pattern lets a business colleague answer the question *"where is order XYZ from customer ABC right now?"* — and lets engineers dig into the technical detail when something goes wrong.

## Overview

An order flows from **System A → Boomi → Azure API Management → System B**, with **Elastic** (functional trace) and **Application Insights** (technical trace) providing independent records of what happened.

Two building blocks make the tracing searchable:

- **Track fields** — searchable business values (e.g. order ID, customer ID) that let you find Boomi executions on functional data. Boomi allows a maximum of 20 track fields, so choose cross-integration values carefully.
- **Trace log messages** — a single JSON schema pushed to a trace queue, drained into Elastic, and correlated across chained processes via a correlation/activity ID.

Shared trace logic lives in **process routes**, versioned by schema version so tracing stays backwards compatible.

## Links

- 📖 Deep-dive tutorial: https://jandaris.com/boomi-functional-integration-tracing-tutorial-a-technical-deep-dive
- 📝 Intro post — *Boomi Functional Integration Tracing: Track Business Processes and Errors*: https://jandaris.com/boomi-functional-integration-tracing
- 🎥 Full walkthrough video: https://www.youtube.com/watch?v=65fsvgdcGYY
- 🛠️ Build with Intersky: https://intersky.nl/

## Trace properties

Trace values come in two flavours: **DDPs** (dynamic document properties — per message) and **DPPs** (dynamic process properties — per process execution). They map onto a single JSON schema — the trace log message — that forms the backbone of the framework.

### DDP — Dynamic Document Property values

| Property | Purpose |
|---|---|
| `DDP_CorrelationId` | Unique value that ties everything together across the flow. |
| `DDP_ActivityId` | Unique key for the individual activity; used as the cache key. |
| `DDP_RegistrationTsp` | Timestamp the trace record was registered. |
| `DDP_ParentStatus` | Functional state of the process: progressing, succeeded or errored. |
| `DDP_EndTsp` | Timestamp the activity completed. |
| `DDP_Action` | Functional description, e.g. "started processing this order" / "order created successfully". |
| `DDP_Severity` | Severity of the trace: `info` or `error`. |
| `DDP_Status` | Status of the traced step. |

### DPP — Dynamic Process Property values

| Property | Purpose |
|---|---|
| `DPP_InterfaceCode` | Unique interface code per Boomi integration. |
| `DPP_InterfaceName` | Human-readable interface name. |
| `DPP_SourceSystemCode` | Short, standardised source system name (e.g. `sysA`). |
| `DPP_TargetSystemCode` | Short, standardised target system name (e.g. `sysB`). |
| `DPP_DomainCode` | Functional domain, e.g. `order`. |
| `DPP_StartTsp` | Timestamp the process started. |

### DPP — Boomi execution context

Standard Boomi runtime/execution information captured on every trace:

| Property | Purpose |
|---|---|
| `DPP_BoomiAccountId` | Boomi account identifier. |
| `DPP_BoomiRuntimeId` | Runtime (Atom/Molecule/Cloud) identifier. |
| `DPP_BoomiRuntimeName` | Runtime name. |
| `DPP_BoomiExecutionId` | Execution identifier for the process run. |
| `DPP_BoomiNodeId` | Node identifier within the runtime. |
| `DPP_BoomiProcessId` | Process identifier. |
| `DPP_BoomiProcessName` | Process name. |

## The flow, step by step

1. **Set trace properties** — initialise DDPs and DPPs, including correlation & activity IDs, interface code, system names, domain, parent status, action, severity, status and schema version.
2. **Push the order onto a queue** — the trigger (imitation) process hands off to the main process.
3. **Configure track fields** — enable track fields (order ID, customer ID) on the main process for searchable executions.
4. **Reuse the correlation** across chained processes — do *not* regenerate the correlation/activity ID.
5. **Attach metadata using a cache** — keyed on the activity ID, using the trace log message profile.
6. **Emit the first functional trace** — via a process route: branch on schema version, set the activity ID, map properties to trace fields, push to the trace queue.
7. **Handle the unhappy flow** — in the catch shape build a failure trace (parent status `failed`, severity `error`).
8. **Map System A → System B** and trace the transformation as needed.
9. **Deliver to System B** through a REST endpoint and emit the final `success` trace.
10. **Ship trace messages to Elastic** — a dedicated process drains the trace queue and posts each message to Elastic.
11. **Run the happy path** — verify search on track fields in Boomi and the full journey in Elastic.
12. **Run the unhappy path** — Azure API Management `validate-content` policy rejects an invalid contract; the failure is traced.
13. **Add the technical view** with Application Insights, connected through Azure API Management as a single connection.

## Repository contents

- Step-by-step Markdown notes for each stage of the tutorial.
- JSON schemas: the trace log message, the System A order, and related profiles.
- Azure API Management policy (including the `validate-content` schema validation used in the unhappy path).

## Author

**Jan Daris** — Integration Architect & Developer
Blog: https://jandaris.com · Build with Intersky: https://intersky.nl/