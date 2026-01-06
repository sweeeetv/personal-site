import azure.functions as func
import os
import json
from azure.data.tables import TableClient # <--- Changed this line
connection_string = os.environ["COSMOS_DB_CONNECTION_STRING"]
    
    # 1. Connect using the Table API Specialist
    # This automatically looks for 'TableEndpoint' in your string!
table_client = TableClient.from_connection_string(conn_str=connection_string, table_name="user-counter")
app = func.FunctionApp()

@app.route(route="GetResumeCounter", auth_level=func.AuthLevel.ANONYMOUS)
def GetResumeCounter(req: func.HttpRequest) -> func.HttpResponse:
    
    

    # 2. Get the specific row (PartitionKey and RowKey are the 'Table' way)
    # We assume you have a row where PartitionKey="visitor_stats" and RowKey="1"
    entity = table_client.get_entity(partition_key="visitor_stats", row_key="1")
    
    # 3. Increment
    entity['count'] += 1
    
    # 4. Save back to the Cloud Vault
    table_client.update_entity(mode='merge', entity=entity)

    return func.HttpResponse(
        json.dumps({"count": entity['count']}),
        mimetype="application/json",
        status_code=200
    )