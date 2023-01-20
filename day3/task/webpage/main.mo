
import Error "mo:base/Error";
import Types "type"; // file name inside it ""
import Array "mo:base/Array";
import Cycles "mo:base/ExperimentalCycles";
import Debug "mo:base/Debug";
import Nat64 "mo:base/Nat64";
import Text "mo:base/Text";
import Blob "mo:base/Blob";
import Nat "mo:base/Nat";


shared actor class BitcoinPricePOC() = this {
    let DATA_POINTS_PER_API : Nat64 = 200;
    let MAX_RESPONSE_BYTES : Nat64 = 10 * 6 * DATA_POINTS_PER_API;

    public query func transform(raw : Types.TransformArgs) : async Types.CanisterHttpResponsePayload {
        let transformed : Types.CanisterHttpResponsePayload = {
            status = raw.response.status;
            body = raw.response.body;
            headers = [
                {
                    name = "Content-Security-Policy";
                    value = "default-src 'self'";
                },
                { name = "Referrer-Policy"; value = "strict-origin" },
                { name = "Permissions-Policy"; value = "geolocation=(self)" },
                {
                    name = "Strict-Transport-Security";
                    value = "max-age=63072000";
                },
                { name = "X-Frame-Options"; value = "DENY" },
                { name = "X-Content-Type-Options"; value = "nosniff" },
            ];
        };
        transformed;
    };

    public type Result<ok, err> = {
        #Ok : ok ;
        #Err : err ;
    };

    public shared (msg) func fetch_ethereum_price() : async Result<Text, Text> {
        let transform_context : Types.TransformContext = {
            function = transform;
            context = Blob.fromArray([]);
        };
        let url = "https://api.coingecko.com/api/v3/simple/price?ids=ethereum&vs_currencies=usd";
        Debug.print(url);

        let request : Types.CanisterHttpRequestArgs = {
            url = url;
            max_response_bytes = ?MAX_RESPONSE_BYTES;
            headers = [];
            body = null;
            method = #get;
            transform = ?transform_context;
        };
        try {
            Cycles.add(2_000_000_000);
            let ic : Types.IC = actor ("aaaaa-aa");
            let response : Types.CanisterHttpResponsePayload = await ic.http_request(request);
            switch (Text.decodeUtf8(Blob.fromArray(response.body))) {
                case null {
                    #Err("Remote response had no body.");
                };
                case (?body) {
                    var headers : Text = "";
                    for (header in response.headers.vals()) {
                        headers := headers # header.name # ": " # header.value # ";";
                        // Debug.print(debug_show response.body);
                        /* r : [123, 34, 101, 116, 104, 101, 114, 101, 117, 109, 34, 58, 123, 34, 117, 115, 100, 34, 58, 49, 50, 49, 57, 46, 52, 51, 48, 50, 51, 51, 48, 50, 57, 56, 56, 51, 56, 44, 34, 117, 115, 100, 95, 109, 97, 114, 107, 101, 116, 95, 99, 97, 112, 34, 58, 49, 52, 54, 57, 54, 51, 54, 54, 53, 54, 51, 50, 46, 56, 54, 52, 44, 34, 117, 115, 100, 95, 50, 52, 104, 95, 118, 111, 108, 34, 58, 50, 56, 50, 55, 48, 53, 53, 51, 54, 48, 46, 54, 51, 52, 56, 50, 48, 53, 44, 34, 117, 115, 100, 95, 50, 52, 104, 95, 99, 104, 97, 110, 103, 101, 34, 58, 48, 46, 50, 51, 54, 50, 48, 54, 50, 51, 49, 51, 55, 54, 49, 52, 50, 48, 56, 44, 34, 108, 97, 115, 116, 95, 117, 112, 100, 97, 116, 101, 100, 95, 97, 116, 34, 58, 49, 54, 55, 49, 56, 57, 51, 54, 50, 51, 125, 125]
                        */
                        // Debug.print(debug_show Blob.fromArray(response.body));
                        /* r : "\7B\22\65\74\68\65\72\65\75\6D\22\3A\7B\22\75\73\64\22\3A\31\32\31\39\2E\33\34\35\35\38\35\32\37\34\32\38\32\37\2C\22\75\73\64\5F\6D\61\72\6B\65\74\5F\63\61\70\22\3A\31\34\36\39\36\33\36\36\35\36\33\32\2E\38\36\34\2C\22\75\73\64\5F\32\34\68\5F\76\6F\6C\22\3A\32\38\32\35\37\32\30\35\39\33\2E\36\31\37\38\33\36\2C\22\75\73\64\5F\32\34\68\5F\63\68\61\6E\67\65\22\3A\30\2E\32\37\31\30\35\32\35\30\36\37\38\35\39\38\33\38\2C\22\6C\61\73\74\5F\75\70\64\61\74\65\64\5F\61\74\22\3A\31\36\37\31\38\39\33\38\30\33\7D\7D"
                        */
                        // Debug.print(debug_show Text.decodeUtf8(Blob.fromArray(response.body)));
                        /* r : ?"{"ethereum":{"usd":1219.3455852742827,"usd_market_cap":146963665632.864,"usd_24h_vol":2825720593.617836,"usd_24h_change":0.2710525067859838,"last_updated_at":1671893803}}"
                        */
                        Debug.print(debug_show response.status); // r ; 200
                        Debug.print(debug_show response.headers); 
                        /* r ; [{name = "Content-Security-Policy"; value = "default-src 'self'"}, {name = "Referrer-Policy"; value = "strict-origin"}, {name = "Permissions-Policy"; value = "geolocation=(self)"}, {name = "Strict-Transport-Security"; value = "max-age=63072000"}, {name = "X-Frame-Options"; value = "DENY"}, {name = "X-Content-Type-Options"; value = "nosniff"}]
                        */
                        Debug.print(debug_show header); 
                        // {name = "X-Content-Type-Options"; value = "nosniff"}

                    };
                    #Ok( "; Body: " # body );
                    // #Ok("Headers: " # headers # "; Body: " # body # "; Status: " # Nat.toText(response.status));
                };
            };
        } catch (err) {
            #Err(Error.message(err));
        };
    };
};



