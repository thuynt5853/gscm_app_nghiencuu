using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;
using System.Web.Script.Serialization;
using WEB.Service.Models.VanBan;

namespace WEB.Service.Controllers.Utils
{
    public class AHSDataUtils : AnDataUtils
    {
        public AHSDataUtils() : base() { }

        public AHSDataUtils(GSTPContext dtContext) : base(dtContext) { }

        public override bool tongDatThuHoi(List<decimal> ids, string reason, string calledBy)
        {
            try
            {
                ThuHoiRequestDTO request = new ThuHoiRequestDTO();
                request.Reason = reason;
                request.DateReall = DateTime.Now;
                request.AllocatedList = GetAnHinhSuThuHoi(ids).Select(x => x.ID).ToList();
                request.UserReall = calledBy;

                string response = wrapperResult(request, DataUtils.END_POINT_VOFFICE_REALLOCATE);
                JavaScriptSerializer j = new JavaScriptSerializer();
                ThuHoiResponseDTO thuHoiResponseDTO = (ThuHoiResponseDTO)j.Deserialize(response, typeof(ThuHoiResponseDTO));
                if ("SUCCESS".Equals(thuHoiResponseDTO.Status))
                {
                    // update status cho tong dat - thu hoi thanh cong ve chua gui
                    if (thuHoiResponseDTO.AllocatedList != null)
                    {
                        List<AHS_TONGDAT> thuhoiList = dt.AHS_TONGDAT.Where(p => thuHoiResponseDTO.AllocatedList.Contains(p.ID)).ToList();
                        foreach (AHS_TONGDAT p in thuhoiList)
                        {
                            // thu hồi thành công chuyển về chưa gửi
                            p.TRANGTHAI = 0;
                            p.NGAYTHUHOI = request.DateReall;
                            p.LYDOTHUHOI = request.Reason;
                            dt.AHS_TONGDAT_DOITUONG.Where(doiTuong => p.ID == (doiTuong.TONGDATID ?? 0)).ToList().ForEach(doiTuong => doiTuong.NGAYGUI = null);
                        }
                    }
                    // update status cho tong dat - thu hoi thanh cong ve chua gui
                    if (thuHoiResponseDTO.ExecutedList != null)
                    {
                        List<AHS_TONGDAT> executedList = dt.AHS_TONGDAT.Where(p => thuHoiResponseDTO.ExecutedList.Contains(p.ID)).ToList();
                        foreach (AHS_TONGDAT p in executedList)
                        {
                            // đã xử lý chuyển trạng thái về 2
                            p.TRANGTHAI = 2;
                        }
                    }
                    dt.SaveChanges();
                    return true;
                }
                if ("FAILURE".Equals(response))
                {
                    return false;
                }
                return false;
            }
            catch (Exception ex)
            {
                return false;
            }
        }

        public override bool tongDat(List<decimal> ids)
        {
            try
            {
                List<TongDatDTO> anDanSu = getAnHinhSu(ids);
                string response = wrapperResult(anDanSu, DataUtils.END_POINT_VOFFICE);
                if ("SUCCESS".Equals(response))
                {
                    List<AHS_TONGDAT> sendSuccessList = dt.AHS_TONGDAT.Where(p => ids.Contains(p.ID)).ToList();
                    foreach (AHS_TONGDAT p in sendSuccessList)
                    {
                        // trang thai da gui
                        if (p.TRANGTHAI == 0) p.TRANGTHAI = 1;
                    }
                    foreach (TongDatDTO an in anDanSu)
                    {
                        List<decimal?> duongSuIdList = an.DoiTuong.Select(doiTuong => doiTuong.DuongSuId).ToList();
                        List<AHS_TONGDAT_DOITUONG> doiTuongSendSuccess = dt.AHS_TONGDAT_DOITUONG.Where(doiTuong => duongSuIdList.Contains(doiTuong.DUONGSUID) && doiTuong.TONGDATID == an.TongDatId).ToList();
                        doiTuongSendSuccess.ForEach(doiTuong => doiTuong.NGAYGUI = DateTime.Now);
                    }
                    dt.SaveChanges();
                    return true;
                }
                if ("FAILURE".Equals(response))
                {
                    return false;
                }
                return false;
            }
            catch (Exception ex)
            {
                return false;
            }
        }

        public List<AHS_TONGDAT> GetAnHinhSuThuHoi(List<decimal> ids)
        {
            List<AHS_TONGDAT> adsTongDats = dt.AHS_TONGDAT.Where(x => ids.Contains(x.ID) && x.TRANGTHAI == 1).ToList();
            return adsTongDats;
        }

        // Án hình sự
        public List<TongDatDTO> getAnHinhSu(List<decimal> ids)
        {
            List<AHS_TONGDAT> adsTongDats = dt.AHS_TONGDAT.Where(x => ids.Contains(x.ID) && (x.TRANGTHAI >= 0 && x.TRANGTHAI <= 2)).ToList();
            HashSet<decimal?> idBieuMaus = new HashSet<decimal?>(adsTongDats.Select(x => x.BIEUMAUID).ToList());
            List<DM_BIEUMAU> allBieuMau = dt.DM_BIEUMAU.Where(x => idBieuMaus.Contains(x.ID)).ToList();
            Dictionary<decimal?, DM_BIEUMAU> mapBieuMau = new Dictionary<decimal?, DM_BIEUMAU>();
            // sonnv: bo xung thong tin van ban di an dan su, HC, PS, LD, HNGD, KDTM
            HashSet<decimal?> idADS_DON = new HashSet<decimal?>(adsTongDats.Select(x => x.VUANID).ToList());
            List<AHS_VUAN> allADSDon = dt.AHS_VUAN.Where(x => idADS_DON.Contains(x.ID)).ToList();
            Dictionary<decimal?, AHS_VUAN> mapAdsDon = new Dictionary<decimal?, AHS_VUAN>();
            Dictionary<decimal?, List<AHS_BICANBICAO>> mapDuongSu = dt.AHS_BICANBICAO
                .Where(x => idADS_DON.Contains(x.VUANID))
                .GroupBy(x => x.VUANID, x => x)
                .ToDictionary(x => x.Key, x => x.ToList());
            // sonnv: bo xung thong tin van ban di
            foreach (AHS_VUAN adsDon in allADSDon)
            {
                mapAdsDon.Add(adsDon.ID, adsDon);
            }

            foreach (DM_BIEUMAU bieuMau in allBieuMau)
            {
                mapBieuMau.Add(bieuMau.ID, bieuMau);
            }
            HashSet<string> usernames = new HashSet<string>(adsTongDats.Where(x => x.NGUOITAO != null).ToList().Select(x => x.NGUOITAO).ToList());

            // danh sach can bo
            Dictionary<string, decimal?> mapUser = new Dictionary<string, decimal?>();
            string sql = "SELECT nsd.USERNAME, dc.ID, dc.HOTEN FROM GSCM.DM_CANBO dc " +
                "JOIN GSCM.QT_NGUOISUDUNG nsd ON dc.ID = nsd.CANBOID " +
                "WHERE nsd.USERNAME IN ";
            string conditions = "(";
            foreach (AHS_TONGDAT tongDat in adsTongDats)
            {
                if (tongDat.NGUOITAO != null)
                {
                    conditions += "'" + tongDat.NGUOITAO + "',";
                }
            }
            if (conditions.Count() != 1)
            {
                conditions = conditions.Remove(conditions.Count() - 1);
                conditions += ")";
                sql += conditions;

                DataTable table = Cls_Comon.GetTableToSQL(sql);

                for (int i = 0; i < table.Rows.Count; i++)
                {
                    string username = table.Rows[i]["USERNAME"].ToString();
                    decimal id = decimal.Parse(table.Rows[i]["ID"].ToString());
                    mapUser.Add(username, id);
                }
            }
            List<TongDatDTO> danhSachTongDat = adsTongDats.Select(x => ToDTO(x, mapBieuMau, mapUser, mapAdsDon, mapDuongSu)).ToList();

            Dictionary<decimal?, TongDatDTO> mapTongDat = new Dictionary<decimal?, TongDatDTO>();
            foreach (TongDatDTO dto in danhSachTongDat)
            {
                mapTongDat.Add(dto.ID, dto);
            }

            List<AHS_TONGDAT_DOITUONG> allDoiTuongs = dt.AHS_TONGDAT_DOITUONG
                .Where(x => mapTongDat.Keys.Contains(x.TONGDATID))
                .ToList();

            HashSet<decimal?> duongSuID = new HashSet<decimal?>(allDoiTuongs.Select(x => x.DUONGSUID).ToList());

            Dictionary<Decimal?, List<AHS_BICANBICAO>> dsBcbc = dt.AHS_BICANBICAO
                .Where(x => duongSuID.Contains(x.ID))
                .GroupBy(x => x.VUANID)
                .ToDictionary(x => x.Key, x => x.ToList());

            Dictionary<Decimal?, List<AHS_NGUOITHAMGIATOTUNG>> dsTgtt = dt.AHS_NGUOITHAMGIATOTUNG
                .Where(x => duongSuID.Contains(x.ID))
                .GroupBy(x => x.VUANID)
                .ToDictionary(x => x.Key, x => x.ToList());

            foreach (TongDatDTO dto in danhSachTongDat)
            {
                dto.DoiTuong = new List<DoiTuongDTO>();
                List<AHS_TONGDAT_DOITUONG> duongSuTongDat = allDoiTuongs.Where(x => dto.ID.Equals(x.TONGDATID) && x.NGAYGUI == null).ToList();

                List<AHS_BICANBICAO> defaultDonDuongSuList;
                if (dsBcbc.TryGetValue(dto.DonId ?? 0, out defaultDonDuongSuList))
                {
                    List<DoiTuongDTO> bcbcTongDat = duongSuTongDat
                        .FindAll(x => defaultDonDuongSuList.Exists(bcbc => x.DUONGSUID == bcbc.ID))
                        .Select(x => ToDTO(dto, x, defaultDonDuongSuList.Where(bcbc => x.DUONGSUID == bcbc.ID).First()))
                        .ToList();
                    dto.DoiTuong.AddRange(bcbcTongDat);
                }
                List<AHS_NGUOITHAMGIATOTUNG> defaultTgttList;
                if (dsTgtt.TryGetValue(dto.DonId ?? 0, out defaultTgttList))
                {
                    List<DoiTuongDTO> tgttTongDat = duongSuTongDat
                        .FindAll(x => defaultTgttList.Exists(ntgtt => x.DUONGSUID == ntgtt.ID))
                        .Select(x => ToDTO(dto, x, defaultTgttList.Where(ntgtt => x.DUONGSUID == ntgtt.ID).First()))
                        .ToList();
                    dto.DoiTuong.AddRange(tgttTongDat);
                }
                if (!dsBcbc.ContainsKey(dto.DonId ?? 0M) && !dsTgtt.ContainsKey(dto.DonId ?? 0M))
                {
                    List<DoiTuongDTO> doiTuong = duongSuTongDat.Select(x => ToDTO<AHS_BICANBICAO>(dto, x, null)).ToList();
                    dto.DoiTuong.AddRange(doiTuong);
                }
            }
            return danhSachTongDat;
        }

        private TongDatDTO ToDTO(AHS_TONGDAT model, Dictionary<decimal?, DM_BIEUMAU> mapBieuMau, Dictionary<string, decimal?> mapUser, Dictionary<decimal?, AHS_VUAN> mapADS_DON, Dictionary<decimal?, List<AHS_BICANBICAO>> mapDuongSu)
        {
            if (model == null)
                return null;

            AHS_TONGDAT entity = model as AHS_TONGDAT;
            TongDatDTO dto = new TongDatDTO();
            dto.ID = entity.ID;
            dto.LoaiAnID = AN_HINH_SU;
            dto.TongDatId = entity.ID;
            dto.DonId = entity.VUANID;
            dto.BieuMauId = entity.BIEUMAUID;
            dto.BieuMau = dto.BieuMauId == null ? null : mapBieuMau[dto.BieuMauId].TENBM;
            dto.ToaAnId = entity.TOAANID;
            dto.IsTdVks = entity.IS_TD_VKS;
            dto.NguoiSua = entity.NGUOISUA;
            dto.NgayTao = entity.NGAYTAO;
            dto.NguoiTao = entity.NGUOITAO;
            dto.MaBieuMau = dto.BieuMauId == null ? null : mapBieuMau[dto.BieuMauId].MABM;
            dto.Magiaidoan = dto.DonId == null ? null : mapADS_DON[dto.DonId].MAGIAIDOAN;
            dto.Mavuviec = dto.DonId == null ? null : mapADS_DON[dto.DonId].MAVUAN;
            dto.Tenvuviec = dto.DonId == null ? null : mapADS_DON[dto.DonId].TENVUAN;
            if (dto.NguoiTao != null)
            {
                decimal? idNguoiTao;
                bool isExists = mapUser.TryGetValue(dto.NguoiTao, out idNguoiTao);
                dto.NguoiTaoId = idNguoiTao;
            }

            if (dto.DonId != null)
            {
                try
                {
                    AHS_BICANBICAO biCao = mapDuongSu[dto.DonId]
                        .Where(x => 1 == x.BICANDAUVU)
                        .First();
                    dto.biCao = biCao.HOTEN;
                    if ((dto.toiDanhId = dt.AHS_SOTHAM_BANAN_DIEU_CHITIET.Where(x => x.BICANID == biCao.ID && 1 == x.ISMAIN).Select(x => x.TOIDANHID).FirstOrDefault()) == null)
                    {
                        dto.toiDanhId = dt.AHS_SOTHAM_CAOTRANG_DIEULUAT.Where(x => x.BICANID == biCao.ID && 1 == x.ISMAIN).Select(x => x.TOIDANHID).FirstOrDefault();
                    }
                }
                catch (Exception ex)
                {
                    dto.biCao = null;
                }
            }

            DM_BIEUMAU dM_BIEUMAU = mapBieuMau[entity.BIEUMAUID];
            if (dM_BIEUMAU != null && dM_BIEUMAU.MABM == "01-HS")
            {
                List<AHS_THAMPHANGIAIQUYET> aDS_DON_XULies = dt.AHS_THAMPHANGIAIQUYET.Where(x => x.VUANID == entity.VUANID).ToList();
                if (aDS_DON_XULies != null && aDS_DON_XULies.Any())
                {
                    dto.Sothongbao = Convert.ToString(aDS_DON_XULies[0].SOQD);
                    dto.Ngaythongbao = Convert.ToDateTime(aDS_DON_XULies[0].NGAYQD);
                    dto.Nguoiky = Convert.ToDecimal(aDS_DON_XULies[0].NGUOIPHANCONGID);

                }
            }
            else if (dM_BIEUMAU != null && (dM_BIEUMAU.MABM == "15-HS") || (dM_BIEUMAU.MABM == "39-HS") || (dM_BIEUMAU.MABM == "40-HS")
                || (dM_BIEUMAU.MABM == "36-HS") || (dM_BIEUMAU.MABM == "37-HS") || (dM_BIEUMAU.MABM == "38-HS") || (dM_BIEUMAU.MABM == "04-HS")
                || (dM_BIEUMAU.MABM == "05-HS") || (dM_BIEUMAU.MABM == "06-HS") || (dM_BIEUMAU.MABM == "07-HS") || (dM_BIEUMAU.MABM == "08-HS"))
            {

                List<AHS_FILE> aDS_FILEs = dt.AHS_FILE.Where(x => x.ID == entity.FILEID).ToList();
                if (aDS_FILEs != null && aDS_FILEs.Any())
                {
                    decimal? maGiaiDoan = aDS_FILEs[0].MAGIAIDOAN;
                    // so tham
                    if (maGiaiDoan != null && maGiaiDoan == 2)
                    {
                        List<AHS_SOTHAM_QUYETDINH_BICAN> aDS_SOTHAM_QUYETDINHs = dt.AHS_SOTHAM_QUYETDINH_BICAN.Where(x => x.QUYETDINHID == dM_BIEUMAU.QUYETDINHID && x.VUANID == entity.VUANID).ToList();
                        if (aDS_SOTHAM_QUYETDINHs != null && aDS_SOTHAM_QUYETDINHs.Any())
                        {
                            dto.Sothongbao = Convert.ToString(aDS_SOTHAM_QUYETDINHs[0].SOQUYETDINH);
                            dto.Ngaythongbao = Convert.ToDateTime(aDS_SOTHAM_QUYETDINHs[0].NGAYQD);
                            dto.Nguoiky = Convert.ToDecimal(aDS_SOTHAM_QUYETDINHs[0].NGUOIKYID);
                        }
                    }

                    // phuc tham
                    else if (maGiaiDoan != null && maGiaiDoan == 3)
                    {
                        List<AHS_PHUCTHAM_QUYETDINH_BICAN> aDS_PHUCTHAM_QUYETDINHs = dt.AHS_PHUCTHAM_QUYETDINH_BICAN.Where(x => x.QUYETDINHID == dM_BIEUMAU.QUYETDINHID && x.VUANID == entity.VUANID).ToList();
                        if (aDS_PHUCTHAM_QUYETDINHs != null && aDS_PHUCTHAM_QUYETDINHs.Any())
                        {
                            dto.Sothongbao = Convert.ToString(aDS_PHUCTHAM_QUYETDINHs[0].SOQUYETDINH);
                            dto.Ngaythongbao = Convert.ToDateTime(aDS_PHUCTHAM_QUYETDINHs[0].NGAYQD);
                            dto.Nguoiky = Convert.ToDecimal(aDS_PHUCTHAM_QUYETDINHs[0].NGUOIKYID);
                        }

                    }


                }
            }
            else
            {
                List<ADS_FILE> aDS_FILEs = dt.ADS_FILE.Where(x => x.ID == entity.FILEID).ToList();
                if (aDS_FILEs != null && aDS_FILEs.Any())
                {
                    decimal? maGiaiDoan = aDS_FILEs[0].MAGIAIDOAN;
                    // so tham
                    if (maGiaiDoan != null && maGiaiDoan == 2)
                    {
                        List<AHS_SOTHAM_QUYETDINH_VUAN> aDS_SOTHAM_QUYETDINHs = dt.AHS_SOTHAM_QUYETDINH_VUAN.Where(x => x.QUYETDINHID == dM_BIEUMAU.QUYETDINHID && x.VUANID == entity.VUANID).ToList();
                        if (aDS_SOTHAM_QUYETDINHs != null && aDS_SOTHAM_QUYETDINHs.Any())
                        {
                            dto.Sothongbao = Convert.ToString(aDS_SOTHAM_QUYETDINHs[0].SOQUYETDINH);
                            dto.Ngaythongbao = Convert.ToDateTime(aDS_SOTHAM_QUYETDINHs[0].NGAYQD);
                            dto.Nguoiky = Convert.ToDecimal(aDS_SOTHAM_QUYETDINHs[0].NGUOIKYID);
                        }
                    }

                    // phuc tham
                    else if (maGiaiDoan != null && maGiaiDoan == 3)
                    {
                        List<AHS_PHUCTHAM_QUYETDINH_VUAN> aDS_PHUCTHAM_QUYETDINHs = dt.AHS_PHUCTHAM_QUYETDINH_VUAN.Where(x => x.QUYETDINHID == dM_BIEUMAU.QUYETDINHID && x.VUANID == entity.VUANID).ToList();
                        if (aDS_PHUCTHAM_QUYETDINHs != null && aDS_PHUCTHAM_QUYETDINHs.Any())
                        {
                            dto.Sothongbao = Convert.ToString(aDS_PHUCTHAM_QUYETDINHs[0].SOQUYETDINH);
                            dto.Ngaythongbao = Convert.ToDateTime(aDS_PHUCTHAM_QUYETDINHs[0].NGAYQD);
                            dto.Nguoiky = Convert.ToDecimal(aDS_PHUCTHAM_QUYETDINHs[0].NGUOIKYID);
                        }
                    }
                }

            }

            return dto;
        }

        private DoiTuongDTO ToDTO<E>(TongDatDTO entityTongDat, AHS_TONGDAT_DOITUONG entity, E duongSuModel)
        {
            if (entityTongDat == null || entity == null) return null;

            DoiTuongDTO dto = new DoiTuongDTO();
            
            dto.MaTuCach = entity.MATUCACH;
            dto.HinhThucGui = entity.HINHTHUCGUI;
            dto.DuongSuId = entity.ID;

            dto.QuocGia = entity.QUOCGIA;
            dto.CoQuan = entity.COQUAN;
            dto.NoiDung = entity.NOIDUNG;
            dto.NguoiTao = entityTongDat.NguoiTao;
            dto.NgayTao = entityTongDat.NgayTao;
            dto.NguoiSua = entityTongDat.NguoiSua;
            dto.QuocGia = entity.QUOCGIA;
            dto.PhatHanhLaiId = entity.PHATHANHLAI_ID;

            dto.IsUTTP = entity.IS_UTTP;
            dto.UTTP = entity.UTTP;
            if (duongSuModel != null)
            {
                if (duongSuModel.GetType() == typeof(AHS_BICANBICAO))
                {
                    AHS_BICANBICAO biCao = duongSuModel as AHS_BICANBICAO;
                    dto.TenDuongSu = entity.IS_UTTP == 1 ? entity.NOINHAN : biCao.HOTEN;
                    dto.SoCMND = biCao.SOCMND;
                    dto.QuocTichId = biCao.QUOCTICHID;
                    dto.TinhId = biCao.TAMTRU ?? biCao.HKTT;
                    dto.HuyenId = biCao.TAMTRU_HUYEN ?? biCao.HKTT_HUYEN;
                    dto.DiaChiChiTiet = entity.IS_UTTP == 1 ? entity.DIACHI : (biCao.TAMTRUCHITIET ?? biCao.KHTTCHITIET);
                    dto.NamSinh = biCao.NAMSINH;
                }
                else if (duongSuModel.GetType() == typeof(AHS_NGUOITHAMGIATOTUNG))
                {
                    AHS_NGUOITHAMGIATOTUNG nguoithamgiatotung = duongSuModel as AHS_NGUOITHAMGIATOTUNG;
                    dto.TenDuongSu = entity.IS_UTTP == 1 ? entity.NOINHAN : nguoithamgiatotung.HOTEN;
                    dto.DiaChiChiTiet = entity.IS_UTTP == 1 ? entity.DIACHI : nguoithamgiatotung.DIACHICHITIET;
                    dto.NamSinh = nguoithamgiatotung.NAMSINH;
                }
            }
            else
            {
                dto.TenDuongSu = entity.NOINHAN;
                dto.DiaChiChiTiet = entity.DIACHI;
            }

            return dto;
        }

    }
}