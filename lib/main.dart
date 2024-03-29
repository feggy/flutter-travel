import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_wisata/cubit/alasan_cubit.dart';
import 'package:travel_wisata/cubit/auth_cubit.dart';
import 'package:travel_wisata/cubit/gender_cubit.dart';
import 'package:travel_wisata/cubit/jemput_cubit.dart';
import 'package:travel_wisata/cubit/jumlah_kursi_cubit.dart';
import 'package:travel_wisata/cubit/page_cubit.dart';
import 'package:travel_wisata/cubit/pemandu_cubit.dart';
import 'package:travel_wisata/cubit/register_cubit.dart';
import 'package:travel_wisata/cubit/supir_cubit.dart';
import 'package:travel_wisata/cubit/transaction_cubit.dart';
import 'package:travel_wisata/cubit/travel_cubit.dart';
import 'package:travel_wisata/cubit/wisata_cubit.dart';
import 'package:travel_wisata/ui/pages/admin/admin_page.dart';
import 'package:travel_wisata/ui/pages/admin/bus_admin_page.dart';
import 'package:travel_wisata/ui/pages/bus_page.dart';
import 'package:travel_wisata/ui/pages/daftar_pemandu_page.dart';
import 'package:travel_wisata/ui/pages/daftar_supir_page.dart';
import 'package:travel_wisata/ui/pages/admin/daftar_transaksi_admin_page.dart';
import 'package:travel_wisata/ui/pages/data_traveler_page.dart';
import 'package:travel_wisata/ui/pages/admin/detail_transaction_admin_page.dart';
import 'package:travel_wisata/ui/pages/konfirmasi_pesanan_page.dart';
import 'package:travel_wisata/ui/pages/laporan_transaksi/laporan_transaksi_page.dart';
import 'package:travel_wisata/ui/pages/laporan_transaksi/tambah_laporan_page.dart';
import 'package:travel_wisata/ui/pages/login_page.dart';
import 'package:travel_wisata/ui/pages/main_page.dart';
import 'package:travel_wisata/ui/pages/pemandu/pemandu_page.dart';
import 'package:travel_wisata/ui/pages/pemandu/sukses_mulai_wisata.dart';
import 'package:travel_wisata/ui/pages/pemandu/sukses_selesai_wisata.dart';
import 'package:travel_wisata/ui/pages/pembayaran_page.dart';
import 'package:travel_wisata/ui/pages/register_page.dart';
import 'package:travel_wisata/ui/pages/splash_page.dart';
import 'package:travel_wisata/ui/pages/sukses_pembayaran_page.dart';
import 'package:travel_wisata/ui/pages/supir/sukses_mulai_travel_page.dart';
import 'package:travel_wisata/ui/pages/supir/sukses_selesai_travel_page.dart';
import 'package:travel_wisata/ui/pages/supir/supir_page.dart';
import 'package:travel_wisata/ui/pages/tambah_agenda_page.dart';
import 'package:travel_wisata/ui/pages/tambah_bus_page.dart';
import 'package:travel_wisata/ui/pages/tambah_wisata_page.dart';
import 'package:travel_wisata/ui/pages/admin/wisata_admin_page.dart';
import 'package:travel_wisata/ui/pages/ubah_profil_page.dart';
import 'package:travel_wisata/ui/pages/wisata_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => GenderCubit()),
        BlocProvider(create: (context) => PageCubit()),
        BlocProvider(create: (context) => JumlahKursiCubit()),
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => RegisterCubit()),
        BlocProvider(create: (context) => PemanduCubit()),
        BlocProvider(create: (context) => SupirCubit()),
        BlocProvider(create: (context) => WisataCubit()),
        BlocProvider(create: (context) => TravelCubit()),
        BlocProvider(create: (context) => TransactionCubit()),
        BlocProvider(create: (context) => JemputCubit()),
        BlocProvider(create: (context) => AlasanCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => const SplashPage(),
          '/main': (context) => const MainPage(),
          Routes.admin: (context) => const AdminPage(),
          '/login': (context) => LoginPage(),
          '/register': (context) => RegisterPage(),
          '/wisata': (context) => const WisataPage(),
          '/bus': (context) => const BusPage(),
          '/data_traveler': (context) => DataTravelerPage(),
          '/konfirmasi_pesanan': (context) => const KonfirmasiPesananPage(),
          '/pembayaran': (context) => const PembayaranPage(),
          '/sukses_pembayaran': (context) => const SuksesPembayaranPage(),
          '/pemandu': (context) => const DaftarPemanduPage(),
          '/supir': (context) => const DaftarSupirPage(),
          '/wisata_admin': (context) => const WisataAdminPage(),
          '/tambah_wisata': (context) => const TambahWisataPage(),
          '/tambah_agenda': (context) => const TambahAgendaPage(),
          '/bus_admin': (context) => const BusAdminPage(),
          '/tambah_bus': (context) => const TambahBusPage(),
          '/transaksi_admin': (context) => const TransactionAdminPage(),
          '/detail_transaksi_admin': (context) =>
              const DetailTransactionAdminPage(),
          '/pemandu_home': (context) => const PemanduPage(),
          '/sukses_wisata': (context) => const SuksesMulaiWisata(),
          '/akhiri_wisata': (context) => const SuksesSelesaiWisata(),
          '/supir_home': (context) => const SupirPage(),
          '/sukses_travel': (context) => const SuksesMulaiTravelPage(),
          '/akhiri_travel': (context) => const SuksesSelesaTravelPage(),
          '/ubah_profil': (context) => const UbahProfilPage(),
          Routes.laporanTransaksiPage: (context) =>
              const LaporanTransaksiPage(),
          Routes.tambahLaporanTransaksiPage: (context) =>
              const TambahLaporanTransaksiPage(),
        },
      ),
    );
  }
}

abstract class Routes {
  static const admin = '/admin';
  static const laporanTransaksiPage = '/admin/laporan_transaksi';
  static const tambahLaporanTransaksiPage = '/admin/laporan_transaksi/tambah';
}
