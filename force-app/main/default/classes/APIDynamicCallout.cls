/**
 * Created by sebastianschepis on 4/27/20.
 */

public abstract class APIDynamicCallout extends APICallout {
    Map<String,String> mapParameters = new Map<String,String>();
    public void setParameter(String name, String val) {
        mapParameters.put(name, val);
    }
    public String getParameter(String name) {
        return mapParameters.get(name);
    }
    public String paramsToJSON() {
        return JSON.serialize(mapParameters);
    }
}