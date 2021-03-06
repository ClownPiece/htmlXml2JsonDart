import 'dart:convert';

import 'package:html_xml_parser/src/utils.dart';

/// This is a HTML/XML element and it is implemented by
/// [RootNode],[ElementNode],[TextNode],[CommentNode]
abstract class Node {
  String type;
  String? tag;
  String? text;
  List<Attribute>? attributes;
  List<Node>? children;

  Node(this.type, {this.tag, this.text, this.attributes, this.children});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {"type": type};

    if (tag != null) map["tag"] = tag;
    if (text != null) map["text"] = text;

    if (attributes != null) {
      map["attributes"] =
          attributes!.map((attribute) => attribute.toMap()).toList();
    }

    if (children != null) {
      map["children"] = children!.map((child) => child.toMap()).toList();
    }
    return map;
  }

  String? toMarKup() {
    return MarkupUtils.mapToMarkup(toMap());
  }

  String toJson() {
    return toString();
  }

  String toString() {
    return jsonEncode(toMap());
  }
}

///It is the starting point of JSON it contains children which are actual HTML/XML elements.
class RootNode extends Node {
  String type = NodeType.ROOT;
  List<Node>? children;

  RootNode(this.children) : super(NodeType.ROOT, children: children);
}

///It is the HTML/XML tag which contains attributes and children.
class ElementNode extends Node {
  String type = NodeType.ELEMENT;
  String? tag;
  List<Attribute>? attributes;
  List<Node>? children;

  ElementNode({this.tag, this.attributes, this.children})
      : super(NodeType.ELEMENT,
            tag: tag, attributes: attributes, children: children);
}

///It is the text content inside HTML/XML element.
///Ex. <div>Hello world!</div>
///Here `Hello world!` is the TextNode
class TextNode extends Node {
  String type = NodeType.TEXT;
  String? text;

  TextNode(this.text) : super(NodeType.TEXT, text: text);
}

///It is the comment in between nodes.
class CommentNode extends Node {
  String type = NodeType.COMMENT;
  String? text;

  CommentNode(this.text) : super(NodeType.COMMENT, text: text);
}

///There are the attributes of HTML/XML element. SO only [ElementNode] supports attribute.
class Attribute {
  String? name;
  String? value;
  String? valueOriginal;

  Attribute(this.name, this.value, [this.valueOriginal]) {
    if (valueOriginal == null) {
      valueOriginal = '"$value"';
    }
  }

  Map<String, dynamic> toMap() {
    return {"name": name, "value": value, "valueOriginal": valueOriginal};
  }

  String toJson() {
    return toString();
  }

  @override
  String toString() {
    return jsonEncode(toMap());
  }
}
