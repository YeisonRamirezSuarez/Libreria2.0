class Validators {
  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return '*Este campo es obligatorio';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return '*Por favor ingresa un correo válido';
    }
    return null;
  }

  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return '*Este campo es obligatorio';
    }
    if (value.length < 6) {
      return '*La contraseña debe tener al menos 6 caracteres';
    }
    if (value.length > 20) {
      return '*La contraseña no puede exceder los 20 caracteres';
    }
    return null;
  }

  static String? phoneValidator(String? value) {
    if (value == null || value.isEmpty) {
      return '*Este campo es obligatorio';
    }

    if (value.length != 10) {
      return '*Por favor ingresa 10 dígitos';
    }

    if (!RegExp(r'^\d{10}$').hasMatch(value)) {
      return '*Por favor ingresa un número de teléfono válido';
    }
    return null;
  }

  static String? addressValidator(String? value) {
    if (value == null || value.isEmpty) {
      return '*Este campo es obligatorio';
    }
    return null;
  }

  static String? requiredFieldValidator(String? value) {
    if (value == null || value.isEmpty) {
      return '*Este campo es obligatorio';
    }
    
    return null;
  }

  static String? urlValidator(String? value) {
    if (value == null || value.isEmpty) {
      return '*Este campo es obligatorio';
    }
    /*final uri = Uri.tryParse(value);
    if (uri == null || !uri.hasAbsolutePath) {
      return '*Por favor ingresa una URL válida';
    }*/
    return null;
  }

  static String? numberValidator(String? value) {
    if (value == null || value.isEmpty) {
      return '*Este campo es obligatorio';
    }

    if (int.tryParse(value) == null) {
      return '*Por favor ingresa un número válido';
    }
    return null;
  }
}
