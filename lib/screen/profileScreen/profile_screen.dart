import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Brand Colors
  final Color primaryOrange = const Color(0xFFFF7A00);
  final Color darkOrange = const Color(0xFFFF5200);
  final Color paleOrange = const Color(0xFFFFF3E8);
  final Color bgColor = const Color(0xFFFAFBFC);
  final Color textDark = const Color(0xFF1A1A1A);
  final Color textGrey = const Color(0xFF8C8C8C);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildProfileCard(),
              const SizedBox(
                height: 24,
              ), // Spacer between profile card and the list
              // Account & Security Section
              _buildSectionHeader('Account & Security'),
              const SizedBox(height: 12),
              _buildListItem(
                Icons.person_outline,
                'Personal Information',
                'Update your personal details',
              ),
              _buildListItem(
                Icons.lock_outline,
                'Change Password',
                'Update your account password',
              ),
              _buildListItem(
                Icons.security,
                'Security Settings',
                'Manage login and security options',
              ),
              _buildListItem(
                Icons.devices,
                'Devices',
                'Manage your connected devices',
              ),

              const SizedBox(height: 20),

              // Preferences Section
              _buildSectionHeader('Preferences'),
              const SizedBox(height: 12),
              _buildListItem(
                Icons.notifications_none,
                'Notifications',
                'Manage your notification preferences',
              ),
              _buildListItem(
                Icons.palette_outlined,
                'Theme',
                'Choose your app appearance',
              ),
              _buildListItem(
                Icons.language,
                'Language',
                'Select your preferred language',
              ),

              const SizedBox(height: 20),

              // Support & More Section
              _buildSectionHeader('Support & More'),
              const SizedBox(height: 12),
              _buildListItem(
                Icons.help_outline,
                'Help Center',
                'Get help and support',
              ),
              _buildListItem(
                Icons.chat_bubble_outline,
                'Contact Us',
                "We're here to help you",
              ),
              _buildListItem(
                Icons.description_outlined,
                'Terms & Privacy',
                'Read our terms and privacy policy',
              ),

              const SizedBox(height: 24),
              _buildLogoutButton(),
              const SizedBox(height: 20), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET FUNCTIONS ---

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Wrap the left side in an Expanded to prevent pushing icons off-screen
        Expanded(
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: paleOrange,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.eco, color: primaryOrange, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Profile',
                      style: TextStyle(
                        color: textDark,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Manage your account and preferences',
                      style: TextStyle(color: textGrey, fontSize: 13),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_none, size: 26),
                  color: textDark,
                  onPressed: () {},
                ),
                Positioned(
                  right: 12,
                  top: 12,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: primaryOrange,
                      shape: BoxShape.circle,
                      border: Border.all(color: bgColor, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.settings_outlined, size: 26),
              color: textDark,
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: paleOrange,
        borderRadius: BorderRadius.circular(20),
        // Subtle background watermark effect
        image: DecorationImage(
          alignment: Alignment.centerRight,
          image: const AssetImage(
            'assets/leaf_watermark.png',
          ), // Placeholder if you have an asset
          colorFilter: ColorFilter.mode(
            Colors.white.withOpacity(0.4),
            BlendMode.srcATop,
          ),
        ),
      ),
      child: Stack(
        children: [
          // Simulated Watermark Icon (if no asset is available)
          Positioned(
            right: -20,
            bottom: -20,
            child: Icon(
              Icons.eco,
              size: 100,
              color: primaryOrange.withOpacity(0.05),
            ),
          ),
          Row(
            children: [
              // Avatar with camera badge
              Stack(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: primaryOrange, width: 2),
                      image: const DecorationImage(
                        image: NetworkImage(''), // Placeholder for 3D avatar
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: primaryOrange,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              // User Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Plaban Maity',
                      style: TextStyle(
                        color: textDark,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'plabanmaity99@gmail.com',
                      style: TextStyle(color: textGrey, fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.workspace_premium,
                            color: primaryOrange,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Premium User',
                            style: TextStyle(
                              color: primaryOrange,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Right Arrow
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.chevron_right,
                  color: Colors.grey,
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        color: primaryOrange,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildListItem(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          // Icon Container
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: paleOrange,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: primaryOrange, size: 22),
          ),
          const SizedBox(width: 16),
          // Text Content (Wrapped in Expanded to prevent overflow)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: textDark,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(subtitle, style: TextStyle(color: textGrey, fontSize: 12)),
              ],
            ),
          ),
          // Trailing Icon
          const Icon(Icons.chevron_right, color: Colors.grey, size: 22),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: primaryOrange, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, color: primaryOrange, size: 20),
            const SizedBox(width: 8),
            Text(
              'Logout',
              style: TextStyle(
                color: primaryOrange,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}