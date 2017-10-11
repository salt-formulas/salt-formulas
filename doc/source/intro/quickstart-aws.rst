`Home <index.html>`_ SaltStack-Formulas Project Introduction

========================================
Quick Deploy on AWS with CloudFormations
========================================

.. contents::
    :backlinks: none
    :local:

AWS Client Setup
================

If you already have pip and a supported version of Python, you can install the
AWS CLI with the following command:

.. code-block:: bash

   $ pip install awscli --upgrade --user

You can then verify that the AWS CLI installed correctly by running aws --version.

.. code-block:: bash

   $ aws --version


Connecting to Amazon Cloud
==========================

Get the Access Keys
-------------------

Access keys consist of an access key ID and secret access key, which are used
to sign programmatic requests that you make to AWS. If you don't have access
keys, you can create them from the AWS Management Console. We recommend that
you use IAM access keys instead of AWS account root user access keys. IAM lets
you securely control access to AWS services and resources in your AWS account.

For general use, the aws configure command is the fastest way to set up your
AWS CLI installation.

.. code-block:: bash

   $ aws configure
   AWS Access Key ID [None]: AKIAIOSFODNN7EXAMPLE
   AWS Secret Access Key [None]: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
   Default region name [None]: us-west-2
   Default output format [None]: json


Launching the CFN Stack
=======================

After successful login you can test the credentials.

.. code-block:: bash

   aws create-stack --stack-name 


--------------

.. include:: navigation.txt
