<?php
/**
 * Kalkun
 * An open source web based SMS Management
 *
 * @package		Kalkun
 * @author		Kalkun Dev Team
 * @license		http://kalkun.sourceforge.net/license.php
 * @link		http://kalkun.sourceforge.net
 */

// ------------------------------------------------------------------------

/**
 * Login Class
 *
 * @package		Kalkun
 * @subpackage	Login
 * @category	Controllers
 */
class Login extends Controller 
{

	/**
	 * Constructor
	 *
	 * @access	public
	 */	
	function __construct()
	{
		parent::__construct();
		$this->load->library('session');		
		$this->load->model('Kalkun_model');	
	}

	// --------------------------------------------------------------------
		 
	public function daemon_sb()
	{
		//echo phpinfo();
		$token='YToyOntzOjg6InVzZXJuYW1lIjtzOjI6InNiIjtzOjg6InBhc3N3b3JkIjtzOjE5OiJzdHVkZW50Ym9vayEqJCVeJiMkIjt9';
		$datain=file_get_contents('https://studentbook.co/akademik/daemond/md/'.$token.'');
		$datatdec=unserialize(base64_decode($datain));
		
		//echo "<pre>";
		//print_r($datatdec);
		
		$this->load->model(array('Kalkun_model', 'Message_model'));
	    $this->load->model('server_alert/server_alert_model', 'plugin_model');
	    
		//$tmp_data = $this->plugin_model->get('active');
		foreach($datatdec as $tmp)
		{
				$data['coding'] = 'default';	
				$data['message'] = $tmp['pesan'];
				$data['date'] = date('Y-m-d H:i:s');
				$data['dest'] = $tmp['no_hp'];
				$data['delivery_report'] = 'default';
				$data['class'] = '1';
				$data['uid'] = '1';
				$idupdate[]=$tmp['id'];
				$this->Message_model->send_messages($data);
		}
		$iddel=base64_encode(implode(",",$idupdate));
		$datadell=file_get_contents('https://studentbook.co/akademik/daemond/mdupdate/'.$token.'/'.$iddel.'');
		echo "<pre>";
		print_r($datadell);
		//print_r($_SERVER);
		
	}
	/**
	 * Index
	 *
	 * Display login form and handle login process
	 *
	 * @access	public   		 
	 */	
	function index()
	{
		$this->load->helper('form');
		if($_POST) $this->Kalkun_model->login();
		$this->load->view('main/login');
	}

	// --------------------------------------------------------------------
	
	/**
	 * Logout
	 *
	 * Logout process, destroy user session
	 *
	 * @access	public   		 
	 */		
	function logout()
	{
		$this->session->sess_destroy();
		redirect('login');
	}
	
	// --------------------------------------------------------------------
	
	/**
	 * Forgot Password
	 *
	 * Forgot password form
	 *
	 * @access	public   		 
	 */		
	function forgot_password()
	{
		$this->load->model('Message_model');
		$this->load->helper('form');
		
		if($_POST)
		{
			$token = $this->Kalkun_model->forgot_password();
			
			if(!$token)
			{
				$this->session->set_flashdata('errorlogin', 'Oh, snap! We couldn\'t find you. Please try again.');	
			}
			else
			{
				// Send token to user
				$data['coding'] = 'default';
				$data['class'] = '1';
				$data['dest'] = $token['phone'];
				$data['date'] = date('Y-m-d H:i:s');
				$data['message'] = 'To reset your Kalkun password please visit '.site_url('login/password_reset/'.$token['token']);
				$data['delivery_report'] = 'default';
				$data['uid'] = 1;
				$this->Message_model->send_messages($data);
				$this->session->set_flashdata('errorlogin', 'Forgot password information already sent to your phone.');	
			}
			redirect('login/forgot_password');
		}
		$this->load->view('main/forgot_password');
	}
	
	// --------------------------------------------------------------------
	
	/**
	 * Password Reset
	 *
	 * Password reset form
	 *
	 * @access	public   		 
	 */		
	function password_reset($token=NULL)
	{
		$this->load->helper('form');
		
		if($_POST)
		{
			$token = $this->input->post('token');
			$user_token = $this->Kalkun_model->valid_token($token);
			$this->Kalkun_model->update_password($user_token['id_user']);
			$this->session->set_flashdata('errorlogin', 'Successfully changed your password.');	
			redirect('login');
		}
		
		if(!$this->Kalkun_model->valid_token($token))
		{
			$this->session->set_flashdata('errorlogin', 'Invalid token detected.');	
			redirect('login/forgot_password');
			
		}
		else
		{
			$data['token'] = $token;
			$this->load->view('main/password_reset', $data);
		}
	}
	
}

/* End of file login.php */
/* Location: ./application/controllers/login.php */ 