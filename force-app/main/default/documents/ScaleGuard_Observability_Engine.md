# ScaleGuard Observability Engine

## Overview
The ScaleGuard Observability Engine provides real-time monitoring, logging, alerting, and traceability capabilities for the ScaleGuard platform. This system enables administrators and developers to monitor automation performance, identify issues quickly, and trace execution paths through correlation IDs.

## Key Components

### 1. Health Dashboard (sgHealthDashboard)
Provides real-time visibility into system health and performance metrics:
- Total jobs executed
- Successful vs failed job counts
- Active job monitoring
- Success and error rates
- Recent error logs with correlation IDs

### 2. Alerting System (sgAlerting)
Real-time alerting for critical issues:
- Instant notification of error events
- Display of active alerts with details
- Visual indication of alert count
- Automatic refresh of alert data

### 3. Traceability System (sgTraceability)
Correlation ID-based log tracing:
- Search logs by correlation ID
- View complete execution trace for specific operations
- Filter and sort log entries
- Detailed error information for debugging

### 4. Demo Data Generator (sgDemoData)
Tools for testing observability features:
- Simulate failure conditions for testing
- Generate demo logs with correlation IDs
- Verify alerting and tracing functionality

## Core Functionality

### Real-time Monitoring
- Live updates through Lightning Message Service
- Automatic refresh of dashboard metrics every 30 seconds
- Real-time alert notifications
- Streaming log events

### Logging Integration
- Structured logging with Nebula Logger patterns
- Correlation ID tracking across all automation layers
- Multi-severity logging (INFO, WARN, ERROR)
- Platform event-based logging for scalability

### Alerting Logic
- Automatic detection of ERROR severity logs
- Immediate alert display when errors occur
- Limited to 20 most recent alerts to prevent performance issues
- Clear visual distinction between error and success states

### Traceability
- Correlation ID-based log search
- Complete execution path tracing
- Timestamp-ordered log viewing
- Support for filtering and sorting

## Technical Implementation

### Apex Components
- **ScaleGuard_Observability.cls**: Core observability utilities
  - Health metrics calculation
  - Log retrieval by correlation ID
  - Demo failure generation
  - Platform event publishing

### Lightning Web Components
- **sgHealthDashboard**: Real-time health metrics display
- **sgAlerting**: Error alert monitoring
- **sgTraceability**: Log correlation search
- **sgDemoData**: Testing utilities

### Data Flow
1. All automation components log events using ScaleGuard_Logger
2. Events are published to platform events (SG_LogEvent__e)
3. Dashboard components subscribe to platform events for real-time updates
4. Alerting system monitors error events in real-time
5. Traceability system allows searching logs by correlation ID

## Security and Performance Considerations

### Security
- All logging respects field-level security
- No sensitive data stored in logs
- Proper RBAC through component permissions
- Secure correlation ID generation

### Performance
- Efficient SOQL queries for metrics calculation
- Limited log retention (1000 recent logs)
- Batch processing for large data sets
- Optimized platform event handling

## Usage Scenarios

### Monitoring System Health
1. Navigate to the Health Dashboard component
2. Monitor real-time metrics including job counts and error rates
3. Identify performance trends and issues

### Troubleshooting Issues
1. When encountering an error, capture the correlation ID
2. Use the Traceability component to search by correlation ID
3. Review complete execution trace for root cause analysis

### Testing Observability Features
1. Use the Demo Data Generator to create test failures
2. Verify that alerts appear in the Alerting component
3. Test traceability by searching for generated correlation IDs

## Configuration and Customization

### Dashboard Metrics
- Metrics are calculated from SG_Job__c and SG_LogEvent__e objects
- Customizable time ranges and filters
- Extensible to include additional metrics

### Alert Thresholds
- Currently configured to alert on all ERROR severity logs
- Can be extended to include WARNING thresholds
- Configurable alert display limits

### Traceability Search
- Supports searching by any correlation ID
- Returns logs ordered by timestamp
- Includes all relevant log information for debugging

## Future Enhancements

### Additional Features
- Advanced alerting rules and conditions
- Email/SMS notifications for critical alerts
- Export functionality for log data
- Historical trend analysis
- Integration with external monitoring systems
- Machine learning-based anomaly detection

### Performance Improvements
- Caching for frequently accessed metrics
- Asynchronous data loading for large datasets
- Optimized database queries
- Enhanced filtering capabilities

## Testing Strategy

### Unit Testing
- All Apex methods have comprehensive test coverage
- Mock data used for metrics calculations
- Error handling scenarios tested
- Integration tests for platform events

### Integration Testing
- End-to-end testing of dashboard components
- Real-time update verification
- Alerting system validation
- Traceability search functionality

### Performance Testing
- Large dataset handling validation
- Response time measurements
- Memory usage monitoring
- Governor limit compliance checks
