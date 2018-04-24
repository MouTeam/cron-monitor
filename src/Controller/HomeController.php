<?php

namespace App\Controller;

use App\Model\FlashType;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;

class HomeController extends Controller
{
    /**
     * @Route("/", name="homepage")
     */
    public function index()
    {
        $this->addFlash(FlashType::ALERT_PRIMARY, 'Hello');
        $this->addFlash(FlashType::ALERT_SECONDARY, 'Hello');
        $this->addFlash(FlashType::ALERT_SUCCESS, 'Hello');
        $this->addFlash(FlashType::ALERT_DANGER, 'Hello');
        $this->addFlash(FlashType::ALERT_WARNING, 'Hello');
        $this->addFlash(FlashType::ALERT_INFO, 'Hello');
        $this->addFlash(FlashType::ALERT_LIGHT, 'Hello');
        $this->addFlash(FlashType::ALERT_DARK, 'Hello');

        return $this->render('home/index.html.twig', [
            'controller_name' => 'HomeController',
        ]);
    }

    /**
     * @Route("/dashboard", name="dashboard")
     */
    public function dashboard()
    {
        return $this->render('home/dashboard.html.twig', [
            'controller_name' => 'HomeController',
        ]);
    }
}
