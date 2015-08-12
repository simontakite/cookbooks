<?php

// load ZabbixApi
require 'ZabbixApiAbstract.class.php';
require 'ZabbixApi.class.php';

// Authentication parameters

// $uri = 'http://10.0.0.2/zabbix/api_jsonrpc.php';
// $username = 'json';
// $password = 'pa55w0rd';

// Authenticate

function zabbix_auth(){
        try {
                // Connect to zabbix api
                $api = new ZabbixApi('http://10.0.0.2/zabbix/api_jsonrpc.php', 'json', 'pa55w0rd');

                // Use extended output for requests
                $api->setDefaultParams(array(
                        'output' => 'extend'
                ));
        }
        catch(Exception $err){
                // Exception in Zabbixapi
                echo $err->getMessage();
        }
}

// Expand array 
function expand_arr($array) {   
        foreach ($array as $key => $value) {
                if (is_array($value)) {
                        echo "<i>".$key."</i>:<br>";
                        expand_arr($value);
                        echo "<br>\n";
                } else {
                        echo "<i>".$key."</i>: ".$value."<br>\n";
                }
        }
}


function zabbix_get_hostbyid($id){
        zabbix_auth();

        //Get host with id
        $hostitem = $api->hostGet(array(
                'filter' => array('hostid' => '$id')));

        foreach($hostitem as $item)
                $hostid = $item->hostid;

        return $hostid;
}

printf('hi');

zabbix_get_hostbyid('10090');

?>