# Integration Design Document - Test Prompts

## TC-INF-006: Integration Design - API Gateway and Service Mesh
**Objective**: Test API management and service communication

### Primary Prompt:
```
Design an integration architecture for a company acquiring 3 smaller companies. Need to 
integrate their existing systems (REST APIs, SOAP services, and message queues) into a 
unified platform while maintaining backward compatibility. Include API versioning, 
rate limiting, monitoring, and gradual migration strategy.
```

### Expected Output:
- API gateway architecture and configuration
- Service mesh implementation strategy
- API versioning and backward compatibility approach
- Integration patterns (synchronous/asynchronous)
- Message queue and event-driven architecture
- Rate limiting and throttling strategies
- API monitoring and analytics
- Gradual migration and rollout strategy

### Success Criteria:
- ✅ Addresses diverse integration requirements
- ✅ Maintains backward compatibility
- ✅ Provides scalable integration architecture
- ✅ Includes comprehensive monitoring

---

## Additional Integration Design Test Scenarios

### TC-INF-018: Enterprise Service Bus (ESB) Modernization
**Objective**: Test enterprise integration and modernization strategies

### Primary Prompt:
```
Modernize a legacy Enterprise Service Bus (ESB) architecture that currently handles 
integration for 50+ applications across different departments. The system processes 
500K messages daily and has become a bottleneck. Design a modern integration platform 
using microservices, API gateways, and event-driven architecture while ensuring 
zero-downtime migration.
```

### Expected Output:
- Modern integration architecture design
- Microservices communication patterns
- Event-driven architecture implementation
- Message routing and transformation strategies
- Integration testing and validation approach
- Zero-downtime migration strategy
- Performance optimization techniques

---

### TC-INF-019: B2B Integration Platform
**Objective**: Test business-to-business integration capabilities

### Primary Prompt:
```
Design a B2B integration platform for a manufacturing company that needs to connect 
with 100+ suppliers and partners. Requirements include EDI processing, real-time 
inventory updates, order management integration, and support for various data formats 
(XML, JSON, CSV, EDI X12). Include security, compliance, and partner onboarding processes.
```

### Expected Output:
- B2B integration architecture
- Multi-protocol and multi-format support
- Partner onboarding and management
- Data transformation and mapping
- Security and compliance framework
- SLA management and monitoring
- Error handling and retry mechanisms

---

### TC-INF-020: Real-time Data Integration
**Objective**: Test real-time data streaming and integration

### Primary Prompt:
```
Design a real-time data integration platform for a financial trading company that needs 
to process market data feeds, execute trades, and update portfolios in real-time. The 
system must handle 1M+ messages per second with sub-millisecond latency requirements. 
Include fault tolerance, data consistency, and regulatory compliance considerations.
```

### Expected Output:
- Real-time streaming architecture
- High-throughput message processing
- Low-latency optimization techniques
- Fault tolerance and resilience strategies
- Data consistency and integrity measures
- Regulatory compliance framework
- Performance monitoring and alerting
