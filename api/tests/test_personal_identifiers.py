from time import sleep
import pytest
from unittest.mock import patch
from settings import Session

from sqlalchemy import and_
from email_validator import EmailNotValidError, validate_email
from phonenumbers.phonenumberutil import NumberParseException

from models import Account, PersonalIdentifier, EmailIdentifier, PhoneNumberIdentifier
from models.personal_identifier import IdentifierType

@pytest.fixture
def db():
    return Session()

def test_personal_identifiers_relationships_and_polymorphism(db):
    account = Account(first_name='Test', last_name='Success')

    account_email = EmailIdentifier(value='good.email@example.com')
    account.primary_email_identifier = account_email
    other_email = EmailIdentifier(value='another.good.email@example.com')

    account_phone_number = PhoneNumberIdentifier(value='+1 1-800-444-4444')
    account.primary_phone_number_identifier = account_phone_number
    other_phone_number = PhoneNumberIdentifier(value='+1 805 334 8626')

    db.add(other_email)
    db.add(other_phone_number)
    db.add(account)
    db.commit()

    assert account.personal_identifiers

    assert other_email.account is None
    assert other_phone_number.account is None

    linked_email = account.primary_email_identifier
    linked_phone_number = account.primary_phone_number_identifier
    assert linked_email.uuid == account_email.uuid
    assert linked_email in account.personal_identifiers
    assert linked_phone_number.uuid == account_phone_number.uuid
    assert linked_phone_number in account.personal_identifiers

    email_linked_account = account_email.account
    phone_number_linked_account = account_phone_number.account
    assert email_linked_account.uuid == account.uuid
    assert phone_number_linked_account.uuid == account.uuid

    queried_email = db.query(PersonalIdentifier).filter(and_(PersonalIdentifier.account==account, PersonalIdentifier.type==IdentifierType.EMAIL)).first()
    queried_phone_number = db.query(PersonalIdentifier).filter(and_(PersonalIdentifier.account==account, PersonalIdentifier.type==IdentifierType.PHONE)).first()
    assert queried_email.uuid == account_email.uuid
    assert queried_phone_number.uuid == account_phone_number.uuid

    [db.delete(record) for record in [account, other_email, other_phone_number]]
    db.commit()

def test_email_validation():
    good_email = EmailIdentifier(value='good.email@example.com')
    assert good_email.value == 'good.email@example.com'

    with pytest.raises(EmailNotValidError):
        _ = EmailIdentifier(value='@not.a good email')

    with pytest.raises(AssertionError):
        account = Account(first_name=' Test', last_name='Success')
        good_phone_number = PhoneNumberIdentifier(value='+1 1-800-444-4444')
        account.primary_email_identifier = good_phone_number

def test_phone_number_validation():
    good_phone_number = PhoneNumberIdentifier(value='+1 1-800-444-4444')
    assert good_phone_number.value == '+18004444444'

    with pytest.raises(NumberParseException):
        _ = PhoneNumberIdentifier(value='987325')

    with pytest.raises(AssertionError):
        account = Account(first_name=' Test', last_name='Success')
        good_email = EmailIdentifier(value='good.email@example.com')
        account.primary_phone_number_identifier = good_email
