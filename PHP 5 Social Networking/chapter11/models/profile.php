<?php

/**
 * Profile model
 */
class Profile{
	
	/**
	 * The registry
	 */
	private $registry;
	
	/**
	 * Profile ID
	 */
	private $id;
	
	/**
	 * Fields which can be saved by the save() method
	 */
	private $savable_profile_fields = array( 'name', 'dino_name', 'dino_dob', 'dino_breed', 'dino_gender', 'photo', 'bio' );
	
	/**
	 * Users ID
	 */
	private $user_id;
	
	/**
	 * Users name
	 */
	private $name;
	
	/**
	 * Dinosaurs name
	 */
	private $dino_name;
	
	/**
	 * Dinosaurs Date of Birth
	 */
	private $dino_dob;
	
	/**
	 * Users bio
	 */
	private $bio;
	
	/**
	 * Dinosaurs breed
	 */
	private $dino_breed;
	
	/**
	 * Dinosaurs gender
	 */
	private $dino_gender;
	
	/**
	 * Users photograph
	 */
	private $photo;
	
	private $valid;
	
	/**
	 * Profile constructor
	 * @param Registry $registry the registry
	 * @param int $id the profile ID
	 * @return void
	 */
	public function __construct( Registry $registry, $id=0 )
	{
		$this->registry = $registry;
		if( $id != 0 )
		{
			$this->id = $id;
			// if an ID is passed, populate based off that
			$sql = "SELECT * FROM profile WHERE user_id=" . $this->id;
			$this->registry->getObject('db')->executeQuery( $sql );
			if( $this->registry->getObject('db')->numRows() == 1 )
			{
				$this->valid = true;
			
				$data = $this->registry->getObject('db')->getRows();
				// populate our fields
				foreach( $data as $key => $value )
				{
					$this->$key = $value;
				}
			}
			else
			{
				$this->valid = false;
			}
			
		}
		else
		{
			$this->valid = false;
		}
	}
	
	/**
	 * Is the profile valid
	 * @return bool
	 */
	public function isValid()
	{
		return $this->valid;
	}
	
	/**
	 * Sets the users name
	 * @param String $name
	 * @return void
	 */
	public function setName( $name )
	{
		$this->name = $name;
	}
	
	/**
	 * Sets the dinosaurs name
	 * @param String $name the name
	 * @return void
	 */
	public function setDinoName( $name )
	{
		$this->dino_name = $name;
	}
	
	/**
	 * Set the dinosaurs data of birth
	 * @param String $dob the date of birth
	 * @param boolean $formatted - indicates if the controller has formatted the dob, or if we need to do it here
	 */
	public function setDinoDOB( $dob, $formatted=true )
	{
		if( $formatted == true )
		{
			$this->dino_dob = $dob;
		}
		else
		{
			$temp = explode('/', $dob );
			$this->dob = $temp[2].'-'.$temp[1].'-'.$temp[0];
		}
	}
	
	/**
	 * Sets the breed of the users dinosaur
	 * @param String $breed
	 * return void
	 */
	public function setDinoBreed( $breed )
	{
		$this->dino_breed = $breed;
	}
	
	/**
	 * Set the gender of the users dinosaur
	 * @param String $gender the gender
	 * @param boolean $checked - indicates if the controller has validated the gender, or if we need to do it
	 * @return void
	 */
	public function setDinoGender( $gender, $checked=true )
	{
		if( $checked == true )
		{
			$this->dino_gender = $gender;
		}
		else
		{
			$genders = array();
			if( in_array( $gender, $genders ) )
			{
				$this->dino_gender = $gender;
			}
		}
	}
	
	/**
	 * Sets the users bio
	 * @param String bio
	 * @return void
	 */
	public function setBio( $bio )
	{
		$this->bio = $bio;
	}
	
	/**
	 * Sets the users profile picture
	 * @param String photo name
	 * @return void
	 */
	public function setPhoto( $photo )
	{
		$this->photo = $photo;
	}
	
	/**
	 * Save the user profile
	 * @return bool
	 */
	public function save()
	{
		// handle the updating of a profile
		if( $registry->getObject('authenticate')->isLoggedIn() && ( $registry->getObject('authenticate')->getUser()->getUserID() ==  $this->id || $registry->getObject('authenticate')->getUser()->isAdmin() == true  ) )
		{
			// we are either the user whose profile this is, or we are the administrator
			$changes = array();
			foreach( $this->saveable_profile_fields as $field )
			{
				$changes[ $field ] = $this->$field;
			}
			$this->registry->getObject('db')->updateRecords( 'profile', $changes, 'user_id=' . $this->id );
			if( $this->registry->getObject('db')->affectedRows() == 1 )
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		else
		{
			return false;
		}
	}
	
	/**
	 * Convert the users profile data to template tags
	 * @param String $prefix prefix for the template tags
	 * @return void
	 */
	public function toTags( $prefix='' )
	{
		foreach( $this as $field => $data )
		{
			if( ! is_object( $data ) && ! is_array( $data ) )
			{
				$this->registry->getObject('template')->getPage()->addTag( $prefix.$field, $data );
			}
		}
	}
	
	/**
	 * Return the users data
	 * @return array
	 */
	public function toArray( $prefix='' )
	{
		$r = array();
		foreach( $this as $field => $data )
		{
			if( ! is_object( $data ) && ! is_array( $data ) )
			{
				$r[ $field ] = $data;
			}
		}
		return $r;
	}
	
	/**
	 * Get the users name
	 * @return String
	 */
	public function getName()
	{
		return $this->name;
	}
	
	/**
	 * Get the users photograph
	 * @return String
	 */
	public function getPhoto()
	{
		return $this->photo;
	}
	
	/**
	 * Get the users ID
	 * @return int
	 */
	public function getID()
	{
		return $this->user_id;
	}
	
}

?>