<?php

namespace App\Controller;

use App\Entity\Cron;
use App\Form\CronType;
use App\Repository\CronRepository;
use Symfony\Bundle\FrameworkBundle\Controller\Controller;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

/**
 * @Route("/cron")
 */
class CronController extends Controller
{
    /**
     * @Route("/", name="cron_index", methods="GET")
     */
    public function index(CronRepository $cronRepository): Response
    {
        return $this->render('cron/index.html.twig', ['crons' => $cronRepository->findAll()]);
    }

    /**
     * @Route("/new", name="cron_new", methods="GET|POST")
     */
    public function new(Request $request): Response
    {
        $cron = new Cron();
        $form = $this->createForm(CronType::class, $cron);
        $form->handleRequest($request);

        if ($form->isSubmitted() && $form->isValid()) {
            $em = $this->getDoctrine()->getManager();
            $em->persist($cron);
            $em->flush();

            return $this->redirectToRoute('cron_index');
        }

        return $this->render('cron/new.html.twig', [
            'cron' => $cron,
            'form' => $form->createView(),
        ]);
    }

    /**
     * @Route("/{id}", name="cron_show", methods="GET")
     */
    public function show(Cron $cron): Response
    {
        return $this->render('cron/show.html.twig', ['cron' => $cron]);
    }

    /**
     * @Route("/{id}/edit", name="cron_edit", methods="GET|POST")
     */
    public function edit(Request $request, Cron $cron): Response
    {
        $form = $this->createForm(CronType::class, $cron);
        $form->handleRequest($request);

        if ($form->isSubmitted() && $form->isValid()) {
            $this->getDoctrine()->getManager()->flush();

            return $this->redirectToRoute('cron_edit', ['id' => $cron->getId()]);
        }

        return $this->render('cron/edit.html.twig', [
            'cron' => $cron,
            'form' => $form->createView(),
        ]);
    }

    /**
     * @Route("/{id}", name="cron_delete", methods="DELETE")
     */
    public function delete(Request $request, Cron $cron): Response
    {
        if ($this->isCsrfTokenValid('delete'.$cron->getId(), $request->request->get('_token'))) {
            $em = $this->getDoctrine()->getManager();
            $em->remove($cron);
            $em->flush();
        }

        return $this->redirectToRoute('cron_index');
    }
}
