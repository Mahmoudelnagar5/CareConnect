import '../../../../core/error/exceptions.dart';
import '../../domain/entities/booking.dart';
import '../../domain/repositories/booking_repository.dart';
import '../models/booking_model.dart';
import '../models/caregiver_model.dart';

/// Contract for the booking remote data source.
///
/// In production this would talk to a backend over Dio. Here it is fulfilled
/// by [MockBookingRemoteDataSource] so the app runs end-to-end without a server.
abstract class BookingRemoteDataSource {
  Future<List<CaregiverModel>> getCaregivers({String? query, String? specialty});
  Future<CaregiverModel> getCaregiverById(String id);
  Future<List<String>> getAvailableSlots(String caregiverId, DateTime date);
  Future<BookingModel> createBooking(BookingRequest request);
  Future<List<BookingModel>> getBookings();
  Future<void> cancelBooking(String bookingId);
}

class MockBookingRemoteDataSource implements BookingRemoteDataSource {
  // In-memory store so created bookings persist within a session.
  final List<BookingModel> _bookings = _seedBookings();

  static List<BookingModel> _seedBookings() {
    final now = DateTime.now();
    return [
      BookingModel(
        id: 'bk_seed_1',
        caregiverId: 'cg_3',
        caregiverName: 'Sofia Reyes',
        caregiverAvatarUrl: '',
        serviceType: 'Post-Surgery Care',
        date: now.add(const Duration(days: 1)),
        startTime: '09:00 AM',
        endTime: '01:00 PM',
        durationHours: 4,
        totalAmount: 152,
        status: BookingStatus.confirmed,
        address: '128 Maple Avenue, Brooklyn, NY',
        notes: 'Wound dressing change required.',
      ),
      BookingModel(
        id: 'bk_seed_2',
        caregiverId: 'cg_1',
        caregiverName: 'Amelia Hart',
        caregiverAvatarUrl: '',
        serviceType: 'Elderly Care',
        date: now.add(const Duration(days: 3)),
        startTime: '08:00 AM',
        endTime: '02:00 PM',
        durationHours: 6,
        totalAmount: 168,
        status: BookingStatus.pending,
        address: '64 Garden Street, Queens, NY',
      ),
      BookingModel(
        id: 'bk_seed_3',
        caregiverId: 'cg_2',
        caregiverName: 'Marcus Lee',
        caregiverAvatarUrl: '',
        serviceType: 'Pediatric Care',
        date: now.subtract(const Duration(days: 5)),
        startTime: '10:00 AM',
        endTime: '01:00 PM',
        durationHours: 3,
        totalAmount: 96,
        status: BookingStatus.completed,
        address: '12 Oak Lane, Manhattan, NY',
      ),
      BookingModel(
        id: 'bk_seed_4',
        caregiverId: 'cg_4',
        caregiverName: 'David Okafor',
        caregiverAvatarUrl: '',
        serviceType: 'Disability Support',
        date: now.subtract(const Duration(days: 12)),
        startTime: '01:00 PM',
        endTime: '05:00 PM',
        durationHours: 4,
        totalAmount: 104,
        status: BookingStatus.cancelled,
        address: '300 River Road, Bronx, NY',
      ),
    ];
  }

  static final List<CaregiverModel> _caregivers = [
    const CaregiverModel(
      id: 'cg_1',
      name: 'Amelia Hart',
      avatarUrl: '',
      specialty: 'Elderly Care',
      rating: 4.9,
      reviewCount: 214,
      yearsExperience: 8,
      hourlyRate: 28,
      skills: ['Mobility Assistance', 'Medication Management', 'Companionship'],
      bio: 'Compassionate caregiver specializing in elderly support with a focus on dignity and independence.',
      isAvailable: true,
      location: 'Brooklyn, NY',
    ),
    const CaregiverModel(
      id: 'cg_2',
      name: 'Marcus Lee',
      avatarUrl: '',
      specialty: 'Pediatric Care',
      rating: 4.8,
      reviewCount: 156,
      yearsExperience: 6,
      hourlyRate: 32,
      skills: ['Child Development', 'First Aid', 'Special Needs'],
      bio: 'Certified pediatric caregiver passionate about creating safe and nurturing environments for children.',
      isAvailable: true,
      location: 'Queens, NY',
    ),
    const CaregiverModel(
      id: 'cg_3',
      name: 'Sofia Reyes',
      avatarUrl: '',
      specialty: 'Post-Surgery Care',
      rating: 4.95,
      reviewCount: 302,
      yearsExperience: 11,
      hourlyRate: 38,
      skills: ['Wound Care', 'Physical Therapy Support', 'Vitals Monitoring'],
      bio: 'Registered nurse providing attentive post-operative recovery care in the comfort of your home.',
      isAvailable: false,
      location: 'Manhattan, NY',
    ),
    const CaregiverModel(
      id: 'cg_4',
      name: 'David Okafor',
      avatarUrl: '',
      specialty: 'Disability Support',
      rating: 4.7,
      reviewCount: 98,
      yearsExperience: 5,
      hourlyRate: 26,
      skills: ['Personal Care', 'Mobility Assistance', 'Meal Preparation'],
      bio: 'Dedicated support worker helping clients live full, independent lives with personalized care.',
      isAvailable: true,
      location: 'Bronx, NY',
    ),
  ];

  Future<void> _delay() => Future.delayed(const Duration(milliseconds: 600));

  @override
  Future<List<CaregiverModel>> getCaregivers({String? query, String? specialty}) async {
    await _delay();
    var results = List<CaregiverModel>.from(_caregivers);
    if (query != null && query.trim().isNotEmpty) {
      final q = query.toLowerCase();
      results = results.where((c) => c.name.toLowerCase().contains(q) || c.specialty.toLowerCase().contains(q)).toList();
    }
    if (specialty != null && specialty.isNotEmpty && specialty != 'All') {
      results = results.where((c) => c.specialty == specialty).toList();
    }
    return results;
  }

  @override
  Future<CaregiverModel> getCaregiverById(String id) async {
    await _delay();
    try {
      return _caregivers.firstWhere((c) => c.id == id);
    } catch (_) {
      throw const ServerException('Caregiver not found');
    }
  }

  @override
  Future<List<String>> getAvailableSlots(String caregiverId, DateTime date) async {
    await _delay();
    // Deterministic pseudo-availability based on the weekday.
    const allSlots = ['08:00 AM', '09:00 AM', '10:00 AM', '11:00 AM', '01:00 PM', '02:00 PM', '03:00 PM', '04:00 PM', '05:00 PM'];
    final seed = date.day + caregiverId.hashCode;
    return [
      for (var i = 0; i < allSlots.length; i++)
        if ((seed + i) % 3 != 0) allSlots[i],
    ];
  }

  @override
  Future<BookingModel> createBooking(BookingRequest request) async {
    await _delay();
    final caregiver = await getCaregiverById(request.caregiverId);
    final startHour = _parseHour(request.startTime);
    final endLabel = _formatHour(startHour + request.durationHours);
    final booking = BookingModel(
      id: 'bk_${DateTime.now().millisecondsSinceEpoch}',
      caregiverId: caregiver.id,
      caregiverName: caregiver.name,
      caregiverAvatarUrl: caregiver.avatarUrl,
      serviceType: request.serviceType,
      date: request.date,
      startTime: request.startTime,
      endTime: endLabel,
      durationHours: request.durationHours,
      totalAmount: caregiver.hourlyRate * request.durationHours,
      status: BookingStatus.confirmed,
      address: request.address,
      notes: request.notes,
    );
    _bookings.insert(0, booking);
    return booking;
  }

  @override
  Future<List<BookingModel>> getBookings() async {
    await _delay();
    return List<BookingModel>.from(_bookings);
  }

  @override
  Future<void> cancelBooking(String bookingId) async {
    await _delay();
    final index = _bookings.indexWhere((b) => b.id == bookingId);
    if (index == -1) throw const ServerException('Booking not found');
    final b = _bookings[index];
    _bookings[index] = BookingModel(
      id: b.id,
      caregiverId: b.caregiverId,
      caregiverName: b.caregiverName,
      caregiverAvatarUrl: b.caregiverAvatarUrl,
      serviceType: b.serviceType,
      date: b.date,
      startTime: b.startTime,
      endTime: b.endTime,
      durationHours: b.durationHours,
      totalAmount: b.totalAmount,
      status: BookingStatus.cancelled,
      address: b.address,
      notes: b.notes,
    );
  }

  int _parseHour(String label) {
    final parts = label.split(' ');
    final hour = int.parse(parts[0].split(':')[0]);
    final isPm = parts[1] == 'PM';
    if (isPm && hour != 12) return hour + 12;
    if (!isPm && hour == 12) return 0;
    return hour;
  }

  String _formatHour(int hour24) {
    final h = hour24 % 24;
    final period = h >= 12 ? 'PM' : 'AM';
    var display = h % 12;
    if (display == 0) display = 12;
    return '${display.toString().padLeft(2, '0')}:00 $period';
  }
}
