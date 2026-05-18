import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Adminuserscreen extends StatefulWidget {
  const Adminuserscreen({super.key});

  @override
  State<Adminuserscreen> createState() =>
      _AdminuserscreenState();
}

class _AdminuserscreenState
    extends State<Adminuserscreen> {

  final supabase =
      Supabase.instance.client;

  List users = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    fetchUsers();
  }

  /// FETCH USERS
  Future fetchUsers() async {

    final response =
        await supabase
            .from('users')
            .select();

    setState(() {

      users = response;
      isLoading = false;
    });
  }

  /// BLOCK / UNBLOCK USER
  Future toggleUserStatus(
    String id,
    bool currentStatus,
  ) async {

    await supabase
        .from('users')
        .update({

          "blocked": !currentStatus,
        })
        .eq("id", id);

    fetchUsers();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Users"),
      ),

      body:

          isLoading

              ? const Center(
                  child:
                      CircularProgressIndicator(),
                )

              : users.isEmpty

                  ? const Center(
                      child: Text(
                        "No Users Found",
                      ),
                    )

                  : ListView.builder(

                      padding:
                          const EdgeInsets.all(12),

                      itemCount: users.length,

                      itemBuilder:
                          (context, index) {

                        final user = users[index];

                        return Card(

                          margin:
                              const EdgeInsets.only(
                            bottom: 15,
                          ),

                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                              15,
                            ),
                          ),

                          child: Padding(

                            padding:
                                const EdgeInsets.all(
                              15,
                            ),

                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,

                              children: [

                                Row(
                                  children: [

                                    CircleAvatar(

                                      radius: 28,

                                      child: Text(

                                        user["name"] !=
                                                    null &&
                                                user["name"]
                                                    .toString()
                                                    .isNotEmpty

                                            ? user["name"][0]

                                            : "U",

                                        style:
                                            const TextStyle(
                                          fontSize: 22,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(
                                      width: 15,
                                    ),

                                    Expanded(

                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,

                                        children: [

                                          Text(

                                            user["name"] ??
                                                "Unknown",

                                            style:
                                                const TextStyle(
                                              fontSize:
                                                  20,
                                              fontWeight:
                                                  FontWeight
                                                      .bold,
                                            ),
                                          ),

                                          const SizedBox(
                                            height: 5,
                                          ),

                                          Text(
                                            user["email"] ??
                                                "",
                                          ),
                                        ],
                                      ),
                                    ),

                                    Container(

                                      padding:
                                          const EdgeInsets.symmetric(
                                        horizontal:
                                            12,
                                        vertical: 6,
                                      ),

                                      decoration:
                                          BoxDecoration(

                                        color:
                                            user["blocked"]

                                                ? Colors
                                                    .red
                                                    .shade100

                                                : Colors
                                                    .green
                                                    .shade100,

                                        borderRadius:
                                            BorderRadius.circular(
                                          20,
                                        ),
                                      ),

                                      child: Text(

                                        user["blocked"]

                                            ? "Blocked"

                                            : "Active",

                                        style:
                                            TextStyle(

                                          color:
                                              user["blocked"]

                                                  ? Colors
                                                      .red

                                                  : Colors
                                                      .green,

                                          fontWeight:
                                              FontWeight
                                                  .bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(
                                  height: 15,
                                ),

                                Row(
                                  children: [

                                    const Icon(
                                      Icons.date_range,
                                    ),

                                    const SizedBox(
                                      width: 10,
                                    ),

                                    Text(
                                      "Joined: ${user["joined"] ?? ""}",
                                    ),
                                  ],
                                ),

                                const SizedBox(
                                  height: 20,
                                ),

                                Row(
                                  children: [

                                    Expanded(

                                      child:
                                          ElevatedButton(

                                        style:
                                            ElevatedButton.styleFrom(

                                          backgroundColor:
                                              user["blocked"]

                                                  ? Colors
                                                      .green

                                                  : Colors
                                                      .red,
                                        ),

                                        onPressed: () {

                                          toggleUserStatus(

                                            user["id"],

                                            user["blocked"],
                                          );
                                        },

                                        child: Text(

                                          user["blocked"]

                                              ? "Unblock User"

                                              : "Block User",

                                          style:
                                              const TextStyle(
                                            color:
                                                Colors
                                                    .white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}