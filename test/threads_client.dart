import 'dart:async';
import 'dart:convert';
import 'package:threads_client/threads_client.dart';
import 'package:test/test.dart';

const personSchema = {
  '\$id': 'https://example.com/person.schema.json',
  '\$schema': 'http://json-schema.org/draft-07/schema#',
  'title': 'Person',
  'type': 'object',
  'required': ['ID'],
  'properties': {
    'ID': {
      'type': 'string',
      'description': "The entity's id.",
    },
    'firstName': {
      'type': 'string',
      'description': "The person's first name.",
    },
    'lastName': {
      'type': 'string',
      'description': "The person's last name.",
    },
    'age': {
      'description': 'Age in years which must be equal to or greater than zero.',
      'type': 'integer',
      'minimum': 0,
    },
  },
};

main() {
  ThreadsClient client;
  String store;
  String address;
  String followKey;
  String readKey;
  String modelID;
  int newAge = 42;
  setUp(() {
    // Create a new threads client
    client = new ThreadsClient();
  });
  tearDown(() async {
    // Shutdown the threads client.
    await client.shutdown();
  });
  test("Create & start a new data store", () async {
    store = await client.newStore();
    await client.start(store);
    expect(store.length, 36);
  });
  test("Register a schema for the new store", () async {
    var jsonData = JsonCodec().encode(personSchema);
    var jsonString = jsonData.toString();
    await client.registerSchema(storeID: store, name: 'Person', schema: jsonString);
    expect(true, true);
  });
  test("Get a link to invite others to the store", () async {
    var link = await client.getStoreLink(store);
    expect(link.addresses.length, greaterThan(0));
    address = link.addresses[0];
    followKey = link.followKey;
    readKey = link.readKey;
  });
  test("Verify invite by starting from invite address", () async {
    try {
      await client.startFromAddress(storeID: store, address: address, followKey: followKey, readKey: readKey);
      expect(true, true);
    } catch (error) {
      expect(error.toString(), "");
    }
  });
  test("Create a new model in the store", () async {
    var model = createPerson();
    try {
      List<Map<String, dynamic>> response = await client.modelCreate(store, 'Person', [model.toJson()]);
      expect(response.length, 1);
      final output = Person.fromJson(response[0]);
      modelID = output.ID;
      expect(true, true);
    } catch (error) {
      expect(error.toString(), "");
    }
  });
  test("Update an existing model in the store", () async {
    var model = createPerson(ID: modelID, age: newAge);
    try {
      await client.modelSave(store, 'Person', [model.toJson()]);
      expect(true, true);
    } catch (error) {
      expect(error.toString(), "");
    }
  });
  test("Check if an ID exists in the store", () async {
    try {
      final response = await client.modelHas(store, 'Person', [modelID]);
      expect(response, true);
    } catch (error) {
      // fail if error
      expect(error.toString(), "");
    }
  });

  test("Fetch a model by its ID", () async {
    try {
      final response = await client.modelFindById(store, 'Person', modelID);
      final person = Person.fromJson(response);
      expect(person.age, newAge);
    } catch (error) {
      // fail if error
      expect(error.toString(), "");
    }
  });

  test("Run an advanced query on store models", () async {
    try {
      JSONQuery queryJSON = JSONQuery.fromJson({
        'ands': [{
            'fieldPath': 'firstName',
            'operation': 'Eq',
            'value': { 'string': 'Adam' }
          },{
            'fieldPath': 'firstName',
            'operation': 'Eq',
            'value': { 'string': 'Doe' }
          }],
        'ors': [{
          'ands': [{
            'fieldPath': 'firstName',
            'operation': 'Eq',
            'value': { 'string': 'Doe' }
          }]
        }],
        'sort': { 'fieldPath': 'firstName', 'desc': true}
      });
      expect(queryJSON.ands, isNotEmpty);
      await client.modelFind(store, 'Person', queryJSON);
    } catch (error) {
      expect(error.toString(), "");
    }
  });

  test("Create an update listener on the store", () async {
    try {
      List<int> events = [];
      Stream<ListenResult> blocker = client.createListener(store);
      var stream = blocker.listen((result){
        Person person = Person.fromJson(result.entity);
        events.add(person.age);
      });

      var ages = [22, 23];
      for (var i=0; i<ages.length; i++) {
        var model = createPerson(ID: modelID, age: ages[i]);
        await client.modelSave(store, 'Person', [model.toJson()]);
      };
      await stream.cancel();
      expect(events.length, ages.length);
    } catch (error) {
      expect(error.toString(), "");
    }
  });
}

class Person {
  final String ID;
  final String firstName;
  final String lastName;
  final int age;
  Person(this.ID, this.firstName, this.lastName, this.age);
  Person.fromJson(Map<String, dynamic> json)
      : ID = json['ID'],
        firstName = json['firstName'],
        lastName = json['lastName'],
        age = json['age'];

  Map<String, dynamic> toJson() =>
    {
      'ID': ID,
      'firstName': firstName,
      'lastName': lastName,
      'age': age
    };
}

Person createPerson ({String ID = '', int age = 24}) {
  return Person(ID, 'Adam', 'Doe', age);
}