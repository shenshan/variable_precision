function obj = getSchema
persistent schemaObject
if isempty(schemaObject)
    schemaObject = dj.Schema(dj.conn, 'varprecision', 'varprecision');
end
obj = schemaObject;
end
