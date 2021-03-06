package fancy.browser;

import js.Browser.document as document;
import js.html.Element;
import js.html.Event;
import js.html.Node;
using thx.Arrays;
using thx.Iterators;

class Dom {
  public static function hasClass(el : Element, className : String) {
    var regex = new EReg('(?:^|\\s)($className)(?!\\S)', 'g');
    return regex.match(el.className);
  }

  public static function addClass(el : Element, className : String) {
    if (!hasClass(el, className))
      el.className += ' $className';
    return el;
  }

  public static function removeClass(el : Element, className : String) {
    var regex = new EReg('(?:^|\\s)($className)(?!\\S)', 'g');
    el.className = regex.replace(el.className, '');
    return el;
  }

  public static function on(el : Element, eventName : String, callback : Event -> Void) {
    el.addEventListener(eventName, callback);
    // TODO: add fallback for older IE
    return el;
  }

  public static function off(el : Element, eventName : String, callback : Event -> Void) {
    el.removeEventListener(eventName, callback);
    return el;
  }

  public static function create(name : String, ?attrs : Map<String, String>, ?children : Array<Element>, ?textContent : String) : Element {
    if (attrs == null) {
      attrs = new Map();
    }
    if (children == null) {
      children = [];
    }

    var classNames = attrs.exists('class') ? attrs.get('class') : '';
    var nameParts = name.split('.');
    name = nameParts.shift();

    if (nameParts.length > 0)
      classNames += ' ' + nameParts.join(' ');

    var el = document.createElement(name);

    attrs.keys().reduce(function (acc : Element, key : String) {
      acc.setAttribute(key, attrs.get(key));
      return acc;
    }, el);

    el.className = classNames;

    for (child in children) {
      el.appendChild(child);
    }

    if (textContent != null) {
      el.appendChild(document.createTextNode(textContent));
    }

    return el;
  }

  public static function insertAtIndex(el : Element, child : Node, index : Int) {
    el.insertBefore(child, el.children[index]);
    return el;
  }

  static function prependChild(el : Element, child : Node) {
      return insertAtIndex(el, child, 0);
  }

  static function prependChildren(el : Element, children : Array<Node>) : Element {
    return children.reduceRight(prependChild, el);
  }

  public static function prepend(el : Element, ?child : Node, ?children : Array<Node>) : Element {
    if (child != null)
      prependChild(el, child);

    return prependChildren(el, children != null ? children : []);
  }

  static function appendChild(el : Element, child : Node) : Element {
    el.appendChild(child);
    return el;
  }

  static function appendChildren(el : Element, children : Array<Node>) : Element {
    return children.reduce(appendChild, el);
  }

  public static function append(el : Element, ?child : Node, ?children : Array<Node>) : Element {
    if (child != null)
      appendChild(el, child);

    return appendChildren(el, children != null ? children : []);
  }

  public static function empty(el : Element) {
    while (el.firstChild != null) {
      el.removeChild(el.firstChild);
    }
    return el;
  }
}
