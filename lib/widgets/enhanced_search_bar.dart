import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EnhancedSearchBar extends StatefulWidget {
  final String hintText;
  final Function(String)? onSearch;
  final VoidCallback? onFilterTap;
  final bool showFilterButton;

  const EnhancedSearchBar({
    super.key,
    this.hintText = "Search for treks, mountains, trails...",
    this.onSearch,
    this.onFilterTap,
    this.showFilterButton = true,
  });

  @override
  State<EnhancedSearchBar> createState() => _EnhancedSearchBarState();
}

class _EnhancedSearchBarState extends State<EnhancedSearchBar>
    with SingleTickerProviderStateMixin {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
      if (_focusNode.hasFocus) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              color: _isFocused ? Colors.white : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: _isFocused 
                    ? Colors.blue.shade400 
                    : Colors.grey.shade200,
                width: _isFocused ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: _isFocused 
                      ? Colors.blue.shade200.withOpacity(0.3)
                      : Colors.grey.shade200,
                  blurRadius: _isFocused ? 15 : 10,
                  offset: const Offset(0, 4),
                  spreadRadius: _isFocused ? 2 : 0,
                ),
              ],
            ),
            child: Row(
              children: [
                // Search Icon
                Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _isFocused 
                        ? Colors.blue.shade600 
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    Icons.search,
                    color: _isFocused ? Colors.white : Colors.grey.shade600,
                    size: 20,
                  ),
                ),
                
                // Search Text Field
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    onChanged: widget.onSearch,
                    decoration: InputDecoration(
                      hintText: widget.hintText,
                      hintStyle: GoogleFonts.poppins(
                        color: Colors.grey.shade500,
                        fontSize: 16,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
                
                // Filter Button (optional)
                if (widget.showFilterButton && widget.onFilterTap != null)
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(15),
                        onTap: widget.onFilterTap,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade100,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Icon(
                            Icons.tune,
                            color: Colors.orange.shade700,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                
                // Clear Button (when text is present)
                if (_controller.text.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(15),
                        onTap: () {
                          _controller.clear();
                          if (widget.onSearch != null) {
                            widget.onSearch!('');
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Icon(
                            Icons.close,
                            color: Colors.grey.shade600,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
