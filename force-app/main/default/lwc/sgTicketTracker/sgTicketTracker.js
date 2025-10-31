import { LightningElement, track } from 'lwc';

export default class SgTicketTracker extends LightningElement {
    @track tickets = [];
    @track isLoading = false;
    @track columns = [
        { label: 'Ticket ID', fieldName: 'id' },
        { label: 'Correlation ID', fieldName: 'correlationId' },
        { label: 'Priority', fieldName: 'priority', type: 'text', cellAttributes: { class: { fieldName: 'priorityClass' } } },
        { label: 'Category', fieldName: 'category' },
        { label: 'Status', fieldName: 'status', type: 'text', cellAttributes: { class: { fieldName: 'statusClass' } } },
        { label: 'Created Date', fieldName: 'createdDate', type: 'date' },
        { label: 'Assigned To', fieldName: 'assignedTo' },
        { label: 'Est. Resolution (hrs)', fieldName: 'resolutionTime', type: 'number' }
    ];
    
    // Mock ticket data
    connectedCallback() {
        this.loadTickets();
    }
    
    loadTickets() {
        this.isLoading = true;
        
        // Simulate API call delay using async/await pattern
        // Remove setTimeout completely from mock implementation
        // Just populate the data immediately
        this.tickets = [
            {
                id: 'TCK-001',
                correlationId: 'SG-1698765432123-456789',
                priority: 'Critical',
                category: 'Data',
                status: 'Open',
                createdDate: '2025-10-30T10:30:00Z',
                assignedTo: 'John Doe',
                resolutionTime: 2,
                priorityClass: 'slds-theme_error',
                statusClass: 'slds-theme_error'
            },
            {
                id: 'TCK-002',
                correlationId: 'SG-1698765432124-567890',
                priority: 'High',
                category: 'Integration',
                status: 'In Progress',
                createdDate: '2025-10-30T09:15:00Z',
                assignedTo: 'Jane Smith',
                resolutionTime: 6,
                priorityClass: 'slds-theme_warning',
                statusClass: 'slds-theme_info'
            },
            {
                id: 'TCK-003',
                correlationId: 'SG-1698765432125-678901',
                priority: 'Medium',
                category: 'Process',
                status: 'Resolved',
                createdDate: '2025-10-29T14:20:00Z',
                assignedTo: 'Bob Johnson',
                resolutionTime: 10,
                priorityClass: 'slds-theme_info',
                statusClass: 'slds-theme_success'
            }
        ];
        this.isLoading = false;
    }
}
