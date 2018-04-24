<?php

namespace App\DataFixtures;

use App\Entity\User;
use Doctrine\Bundle\FixturesBundle\Fixture;
use Doctrine\Common\Persistence\ObjectManager;
use Symfony\Component\Security\Core\Encoder\UserPasswordEncoderInterface;

/**
 * @author Alexandre PAVY <pavy.alexandre@gmail.com>
 */
class UserFixtures extends Fixture
{
    /** @var UserPasswordEncoderInterface */
    private $passwordEncoder;

    /**
     * @param UserPasswordEncoderInterface $passwordEncoder
     */
    public function __construct(UserPasswordEncoderInterface $passwordEncoder)
    {
        $this->passwordEncoder = $passwordEncoder;
    }

    /**
     * @param ObjectManager $manager
     */
    public function load(ObjectManager $manager)
    {
        $admin = new User();
        $admin->setUsername('admin');
        $admin->setEmail('admin@email.fr');
        $admin->setEnabled(true);
        $admin->addRole('ROLE_ADMIN');
        $admin->setPassword($this->passwordEncoder->encodePassword($admin, 'admin'));

        $manager->persist($admin);

        $user = new User();
        $user->setUsername('user');
        $user->setEmail('user@email.fr');
        $user->setEnabled(false);
        $admin->addRole('ROLE_USER');
        $user->setPassword($this->passwordEncoder->encodePassword($user, 'user'));

        $manager->persist($user);

        $manager->flush();
    }
}
