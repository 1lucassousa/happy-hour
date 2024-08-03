import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:happy_hour/modules/domain/entities/usuario.dart';
import 'package:happy_hour/modules/presenter/history_page.dart';
import 'package:happy_hour/modules/util/widgets.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _ctrlName = TextEditingController();
  final _ctrlValor = TextEditingController();
  List<Usuario> users = [];

  final DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm:ss');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Happy Hour'),
        ),
        leading: const Icon(
          Icons.history,
          color: Colors.transparent,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HistoryPage()));
            },
            icon: const Icon(Icons.history),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _textFormFieldName('Nome', controller: _ctrlName),
          const SizedBox(
            height: 20,
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.6,
            padding: const EdgeInsets.all(10),
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .orderBy('name')
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (users.isNotEmpty) {
                  users = [];
                }

                if (snapshot.hasData) {
                  for (var doc in snapshot.data.docs) {
                    users.add(Usuario(doc.get('name'), doc.get('countChopp')));
                  }
                }

                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onLongPress: () async {
                        await dialogRemove(context, users[index]);
                      },
                      child: ListTile(
                        title: Text(users[index].name,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        trailing: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                  onPressed: () async {
                                    if (users[index].countChopp != 0) {
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(users[index].name)
                                          .update(({
                                            'countChopp':
                                                users[index].countChopp - 1
                                          }));

                                      await FirebaseFirestore.instance.
                                          collection('history')
                                          .doc(DateTime.now().toString())
                                          .set(
                                            ({
                                              'id': DateTime.now().toString(),
                                              'action':
                                                  "${users[index].name} removeu um chopp as ${formatter.format(DateTime.now())}",
                                            }),
                                          );
                                    }
                                  },
                                  icon: const Icon(Icons.remove)),
                              Text(users[index].countChopp.toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              IconButton(
                                  onPressed: () async {
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(users[index].name)
                                        .update(({
                                          'countChopp':
                                              users[index].countChopp + 1
                                        }));

                                    await FirebaseFirestore.instance
                                        .collection('history')
                                        .doc(DateTime.now().toString())
                                        .set(
                                          ({
                                            'id': DateTime.now().toString(),
                                            'action':
                                                "${users[index].name} pediu um chopp as ${formatter.format(DateTime.now())}",
                                          }),
                                        );
                                  },
                                  icon: const Icon(Icons.add)),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          buildButtonFecharConta(context)
        ],
      ),
    );
  }

  _textFormFieldName(
    String label, {
    TextEditingController? controller,
    FormFieldValidator<String>? validator,
  }) {
    return TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          suffixIcon: const Icon(Icons.person),
          labelStyle: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
          labelText: label,
        ),
        onFieldSubmitted: (value) async {
          if (value.isNotEmpty) {
            if (users.any((user) => user.name == value)) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Este nome já foi inserido no Happy Hour'),
                ),
              );
            } else {
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(_ctrlName.text)
                  .set(
                    ({
                      'name': _ctrlName.text,
                      'countChopp': 0,
                    }),
                  );
              _ctrlName.text = "";
            }
          }
        });
  }

  _textFormFieldValor(
    String label, {
    TextEditingController? controller,
    FormFieldValidator<String>? validator,
    StateSetter? setState,
  }) {
    return TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          suffixIcon: const Icon(Icons.money),
          labelStyle: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
          labelText: label,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          CentavosInputFormatter(),
        ],
        onFieldSubmitted: (value) async {
          setState!(() {});
        });
  }

  SizedBox buildButtonFecharConta(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: defaultColor,
        ),
        onPressed: () async {
          if (users.isNotEmpty) {
            dialog(context);
          }
        },
        child: const Text(
          'Fechar a conta',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Future dialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: ((context, setStateBuilder) {
            StateSetter setState = setStateBuilder;
            return AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0))),
              title: const Text("Fechar Conta"),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _textFormFieldValor("Valor do Chopp",
                        controller: _ctrlValor, setState: setState),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: _ctrlValor.text.isEmpty
                          ? const Center(
                              child: Text(
                                'Insira o valor do Chopp acima',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: users.length,
                              itemBuilder: (context, index) {
                                return users[index].countChopp != 0
                                    ? ListTile(
                                        title: Text(users[index].name,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        trailing: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Text(
                                                  '${users[index].countChopp}  *  ${_ctrlValor.text}  = ',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text(
                                                  ("R\$ ${(users[index].countChopp * double.parse(_ctrlValor.text.replaceAll(',', '.'))).toStringAsFixed(2).replaceAll('.', ',')}"),
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ],
                                          ),
                                        ),
                                      )
                                    : const SizedBox();
                              },
                            ),
                    )
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text("Voltar"),
                  onPressed: () {
                    Navigator.of(context).pop(null);
                  },
                ),
              ],
            );
          }),
        );
      },
    );
  }

  Future dialogRemove(BuildContext context, Usuario usuario) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          title: const Text("Remover"),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [Text('Deseja remover ${usuario.name} do Happy Hour?')],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Não",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                "Sim",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              onPressed: () async {
                Navigator.of(context).pop();

                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(usuario.name)
                    .delete();

                setState(() {});
              },
            ),
          ],
        );
      },
    );
  }
}
