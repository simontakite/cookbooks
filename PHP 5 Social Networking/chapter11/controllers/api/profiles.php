<?php
/**
 * API Delegate: Profiles
 * Proof of concept
 */
class APIDelegate{
	
	private $registry;
	
	private $caller;
	
	public function __construct( Registry $registry, $caller )
	{
		$this->caller = $caller;
		$this->registry = $registry;
		$urlBits = $this->registry->getObject('url')->getURLBits();
		if( isset( $urlBits[2] ) )
		{
			$this->aProfile( intval( $urlBits[2] ) );
		}
		else
		{
			$this->listProfiles();
		}
		
	}
	
	private function listProfiles()
	{
		$this->caller->requireAuthentication();
		if( $_SERVER['REQUEST_METHOD'] == 'POST' )
		{
			// we can't create a profile as we already have one!
			header('HTTP/1.0 405 Method Not Allowed');
			exit();
		}
		else
		{
			// ideally, we would paginate this, and/or put some filtering in i.e. filter by name starting with A,B,C, etc.
			$sql = "SELECT user_id, name FROM profile";
			$this->registry->getObject('db')->executeQuery( $sql );
			$r = array();
			while( $row = $this->registry->getObject('db')->getRows() )
			{
				$r[] = $row;
			}
			header('HTTP/1.0 200 OK');
			echo json_encode( $r );
			exit();
			
		}
	}
	
	private function aProfile( $pid )
	{
		$this->caller->requireAuthentication();
		require_once( FRAMEWORK_PATH . 'models/profile.php' );
		if( $_SERVER['REQUEST_METHOD'] == 'PUT' )
		{
			
			if( $pid == $this->registry->getObject('authenticate')->getUser()->getUserID() )
			{
				$profile = new Profile( $this->registry, $pid );
				if( $profile->isValid() )
				{
					$data = $this->caller->getRequestData();
					$profile->setName( $this->registry->getObject('db')->sanitizeData( $data['name'] ) );
					$profile->setDinoName( $this->registry->getObject('db')->sanitizeData( $data['dino_name'] ) );
					// etc, set all appropriate methods
					$profile->save();
					header('HTTP/1.0 204 No Content');
					exit();
				}
				else
				{
					header('HTTP/1.0 404 Not Found');
					exit();
				}
			}
			else
			{
				header('HTTP/1.0 403 Forbidden');
				exit();
			}
		}
		else
		{
			$profile = new Profile( $this->registry, $pid );
			if( $profile->isValid() )
			{
				header('HTTP/1.0 200 OK');
				echo json_encode( $profile->toArray() );
				exit();
			}
			else
			{
				header('HTTP/1.0 404 Not Found');
				exit();
			}
		}
	}
	
	
	
}




?>