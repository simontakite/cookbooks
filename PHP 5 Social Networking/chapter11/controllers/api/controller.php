<?php
/**
 * API Controller
 */
class Apicontroller{
	
	/**
	 * Allowable API Controllers, for control to be delegated to
	 */
	private $allowableAPIControllers = array( 'profiles' );
	
	/**
	 * Request data
	 */
	 private $requestData = array();
	
	/**
	 * API Controller Constructor
	 * @param Registry $registry the registry
	 * @param boolean $directCall
	 * @return void
	 */
	public function __construct( Registry $registry, $directCall=true )
	{
		$this->registry = $registry;
		$apiController = $registry->getObject('url')->getURLBit(1);
		$this->delegateControl( $apiController );
	}
	
	/**
	 * Pass control to a delegate
	 * @param String $apiController the delegate
	 * @return void
	 */
	private function delegateControl( $apiController )
	{
		
		if( $apiController != ''  && in_array( $apiController, $this->allowableAPIControllers ) )
		{
			require_once( FRAMEWORK_PATH . 'controllers/api/' . $apiController . '.php' );
			$api = new APIDelegate( $this->registry, $this );
		}	
		else
		{
			header('HTTP/1.0 404 Not Found');
       		exit();
		}
	}
	
	/**
	 * Request authentication for access to API methods, called by delegates
	 * @return void
	 */
	public function requireAuthentication()
	{
		if( !isset( $_SERVER['PHP_AUTH_USER'] ) ) 
		{
    		header('WWW-Authenticate: Basic realm="DinoSpace API Login"');
    		header('HTTP/1.0 401 Unauthorized');
       		exit();
		} 
		else 
		{
			$user = $_SERVER['PHP_AUTH_USER'];
			$password = $_SERVER['PHP_AUTH_PW'];
			$this->registry->getObject('authenticate')->postAuthenticate( $user, $password, false );
			if( ! $this->registry->getObject('authenticate')->isLoggedIn() )
			{
				header('HTTP/1.0 401 Unauthorized');
       			exit();
			}
		}
	}
	
	/**
	 * Get the type of request
	 * @return array
	 */
	public function getRequestData()
	{
		if( $_SERVER['REQUEST_METHOD'] == 'GET' )
		{
			$this->requestData = $_GET;
		}
		elseif( $_SERVER['REQUEST_METHOD'] == 'POST' )
		{
			$this->requestData = $_POST;
		}
		elseif( $_SERVER['REQUEST_METHOD'] == 'PUT' ) 
		{  
		    parse_str(file_get_contents('php://input'), $this->requestData );  
		} 
		elseif( $_SERVER['REQUEST_METHOD'] == 'DELETE' )
		{
			parse_str(file_get_contents('php://input'), $this->requestData );  
		}
		return $this->requestData;
	}
	
	
	
	
}




?>