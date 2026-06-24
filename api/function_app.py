import azure.functions as func
import os
import json
from azure.core.exceptions import ResourceNotFoundError
from azure.data.tables import TableClient # <--- Changed this line
connection_string = os.environ["COSMOS_DB_CONNECTION_STRING"]
    
    # 1. Connect using the Table API Specialist
    # This automatically looks for 'TableEndpoint' in your string!
table_client = TableClient.from_connection_string(conn_str=connection_string, table_name="visitor-counter-table")
app = func.FunctionApp()

@app.route(route="getresumecounter", auth_level=func.AuthLevel.ANONYMOUS)
def getresumecounter(req: func.HttpRequest) -> func.HttpResponse:
    
    # 2. Get the specific row (PartitionKey and RowKey are the 'Table' way)
    #PartitionKey="visitor_stats" and RowKey="1"
    try:
        entity = table_client.get_entity(partition_key="visitor_stats", row_key="1")
        # 3. Increment
        entity['count'] += 1
        # 4. Save back to the Cloud Vault
        table_client.update_entity(mode='merge', entity=entity)
    except ResourceNotFoundError:
        # If the entity doesn't exist, create it with count=1
        entity = {
            'PartitionKey': "visitor_stats",
            'RowKey': "1",
            'count': 1
        }
        table_client.create_entity(entity=entity) 
    except Exception as e:
        import logging
        logging.error(f"Database error: {e}")
        return func.HttpResponse("Database Error", status_code=500)

    return func.HttpResponse(
        json.dumps({"count": entity['count']}),
        mimetype="application/json",
        status_code=200
    )

   