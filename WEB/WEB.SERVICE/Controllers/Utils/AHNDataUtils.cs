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
    public class AHNDataUtils : AnDataUtils
    {
        public AHNDataUtils() : base() { }

        public AHNDataUtils(GSTPContext dtContext) : base(dtContext) { }

        public override bool tongDatThuHoi(List<decimal> ids, string reason, string calledBy)
        {
            try
            {
                ThuHoiRequestDTO request = new ThuHoiRequestDTO();
                request.Reason = reason;
                request.DateReall = DateTime.Now;
                request.AllocatedList = GetAnHonNhanThuHoi(ids).Select(x => x.ID).ToList();
                request.UserReall = calledBy;

                string response = wrapperResult(request, DataUtils.END_POINT_VOFFICE_REALLOCATE);
                JavaScriptSerializer j = new JavaScriptSerializer();
                ThuHoiResponseDTO thuHoiResponseDTO = (ThuHoiResponseDTO)j.Deserialize(response, typeof(ThuHoiResponseDTO));
                if ("SUCCESS".Equals(thuHoiResponseDTO.Status))
                {
                    // update status cho tong dat - thu hoi thanh cong ve chua gui
                    if (thuHoiResponseDTO.AllocatedList != null)
                    {
                        List<AHN_TONGDAT> thuhoiList = dt.AHN_TONGDAT.Where(p => thuHoiResponseDTO.AllocatedList.Contains(p.ID)).ToList();
                        foreach (AHN_TONGDAT p in thuhoiList)
                        {
                            // thu hồi thành công chuyển về chưa gửi
                            p.TRANGTHAI = 0;
                            p.NGAYTHUHOI = request.DateReall;
                            p.LYDOTHUHOI = request.Reason;
                            dt.AHN_TONGDAT_DOITUONG.Where(doiTuong => p.ID == (doiTuong.TONGDATID ?? 0)).ToList().ForEach(doiTuong => doiTuong.NGAYGUI = null);
                        }
                    }
                    // update status cho tong dat - thu hoi thanh cong ve chua gui
                    if (thuHoiResponseDTO.ExecutedList != null)
                    {
                        List<AHN_TONGDAT> executedList = dt.AHN_TONGDAT.Where(p => thuHoiResponseDTO.ExecutedList.Contains(p.ID)).ToList();
                        foreach (AHN_TONGDAT p in executedList)
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
                List<TongDatDTO> anHonNhan = GetAnHonNhanGiaDinh(ids);
                string response = wrapperResult(anHonNhan, DataUtils.END_POINT_VOFFICE);
                if ("SUCCESS".Equals(response))
                {
                    List<AHN_TONGDAT> sendSuccessList = dt.AHN_TONGDAT.Where(p => ids.Contains(p.ID)).ToList();
                    foreach (AHN_TONGDAT p in sendSuccessList)
                    {
                        // trang thai da gui
                        if (p.TRANGTHAI == 0) p.TRANGTHAI = 1;
                    }
                    foreach (TongDatDTO an in anHonNhan)
                    {
                        List<decimal?> duongSuIdList = an.DoiTuong.Select(doiTuong => doiTuong.DuongSuId).ToList();
                        List<AHN_TONGDAT_DOITUONG> doiTuongSendSuccess = dt.AHN_TONGDAT_DOITUONG.Where(doiTuong => duongSuIdList.Contains(doiTuong.DUONGSUID) && doiTuong.TONGDATID == an.TongDatId).ToList();
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

        // Án hôn nhân gia đình
        public List<TongDatDTO> GetAnHonNhanGiaDinh(List<decimal> ids)
        {
            List<AHN_TONGDAT> adsTongDats = dt.AHN_TONGDAT.Where(x => ids.Contains(x.ID) && (x.TRANGTHAI >= 0 && x.TRANGTHAI <= 2)).ToList();
            HashSet<decimal?> idBieuMaus = new HashSet<decimal?>(adsTongDats.Select(x => x.BIEUMAUID).ToList());
            List<DM_BIEUMAU> allBieuMau = dt.DM_BIEUMAU.Where(x => idBieuMaus.Contains(x.ID)).ToList();
            Dictionary<decimal?, DM_BIEUMAU> mapBieuMau = new Dictionary<decimal?, DM_BIEUMAU>();
            foreach (DM_BIEUMAU bieuMau in allBieuMau)
            {
                mapBieuMau.Add(bieuMau.ID, bieuMau);
            }

            // sonnv: bo xung thong tin van ban di an dan su, HC, PS, LD, HNGD, KDTM
            HashSet<decimal?> idADS_DON = new HashSet<decimal?>(adsTongDats.Select(x => x.DONID).ToList());
            List<AHN_DON> allADSDon = dt.AHN_DON.Where(x => idADS_DON.Contains(x.ID)).ToList();
            Dictionary<decimal?, AHN_DON> mapAdsDon = new Dictionary<decimal?, AHN_DON>();
            Dictionary<decimal?, List<AHN_DON_DUONGSU>> mapDuongSu = dt.AHN_DON_DUONGSU
                .Where(x => idADS_DON.Contains(x.DONID))
                .GroupBy(x => x.DONID, x => x)
                .ToDictionary(x => x.Key, x => x.ToList());
            // sonnv: bo xung thong tin van ban di
            foreach (AHN_DON adsDon in allADSDon)
            {
                mapAdsDon.Add(adsDon.ID, adsDon);
            }

            // danh sach can bo
            Dictionary<string, decimal?> mapUser = new Dictionary<string, decimal?>();
            string sql = "SELECT nsd.USERNAME, dc.ID, dc.HOTEN FROM GSCM.DM_CANBO dc " +
                "JOIN GSCM.QT_NGUOISUDUNG nsd ON dc.ID = nsd.CANBOID " +
                "WHERE nsd.USERNAME IN ";
            string conditions = "(";
            foreach (AHN_TONGDAT tongDat in adsTongDats)
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

            //List<TongDatDTO> danhSachTongDat = adsTongDats.Select(x => ToDTO(x, mapBieuMau)).ToList();
            List<TongDatDTO> danhSachTongDat = adsTongDats.Select(x => ToDTO(x, mapBieuMau, mapUser, mapAdsDon, mapDuongSu)).ToList();

            Dictionary<decimal?, TongDatDTO> mapTongDat = new Dictionary<decimal?, TongDatDTO>();
            foreach (TongDatDTO dto in danhSachTongDat)
            {
                mapTongDat.Add(dto.ID, dto);
            }

            List<AHN_TONGDAT_DOITUONG> allDoiTuongs = dt.AHN_TONGDAT_DOITUONG
                .Where(x => mapTongDat.Keys.Contains(x.TONGDATID))
                .ToList();

            HashSet<decimal?> duongSuID = new HashSet<decimal?>(allDoiTuongs.Select(x => x.DUONGSUID).ToList());
            Dictionary<decimal, AHN_DON_DUONGSU> donDuongSu = dt.AHN_DON_DUONGSU
                .Where(x => duongSuID.Contains(x.ID))
                .ToDictionary(x => x.ID, x => x);

            AHN_DON_DUONGSU defaultDonDuongSu;
            foreach (TongDatDTO dto in danhSachTongDat)
            {
                List<AHN_TONGDAT_DOITUONG> subList = allDoiTuongs.Where(x => dto.ID.Equals(x.TONGDATID) && x.NGAYGUI == null).ToList();
                List<DoiTuongDTO> doiTuong = subList.Select(x => ToDTO(dto, x, donDuongSu.TryGetValue(x.DUONGSUID ?? default(decimal), out defaultDonDuongSu) ? defaultDonDuongSu : null)).ToList();
                dto.DoiTuong = doiTuong;
            }
            return danhSachTongDat;
        }

        public List<AHN_TONGDAT> GetAnHonNhanThuHoi(List<decimal> ids)
        {
            List<AHN_TONGDAT> adsTongDats = dt.AHN_TONGDAT.Where(x => ids.Contains(x.ID) && x.TRANGTHAI == 1).ToList();
            return adsTongDats;
        }

        private TongDatDTO ToDTO(AHN_TONGDAT model, Dictionary<decimal?, DM_BIEUMAU> mapBieuMau, Dictionary<string, decimal?> mapUser, Dictionary<decimal?, AHN_DON> mapADS_DON, Dictionary<decimal?, List<AHN_DON_DUONGSU>> mapDuongSu)
        {
            if (model == null)
                return null;

            AHN_TONGDAT entity = model as AHN_TONGDAT;
            TongDatDTO dto = new TongDatDTO();
            dto.ID = entity.ID;
            dto.LoaiAnID = AN_HON_NHAN_GIA_DINH;
            dto.TongDatId = entity.ID;
            dto.DonId = entity.DONID;
            dto.BieuMauId = entity.BIEUMAUID;
            dto.ToaAnId = entity.TOAANID;
            dto.IsTdVks = entity.IS_TD_VKS;
            dto.NguoiSua = entity.NGUOISUA;
            dto.NgayTao = entity.NGAYTAO;
            dto.NguoiTao = entity.NGUOITAO;
            dto.BieuMau = dto.BieuMauId == null ? null : mapBieuMau[dto.BieuMauId].TENBM;
            dto.MaBieuMau = dto.BieuMauId == null ? null : mapBieuMau[dto.BieuMauId].MABM;
            dto.Mavuviec = dto.DonId == null ? null : mapADS_DON[dto.DonId].MAVUVIEC;
            dto.Tenvuviec = dto.DonId == null ? null : mapADS_DON[dto.DonId].TENVUVIEC;
            dto.Magiaidoan = dto.DonId == null ? null : mapADS_DON[dto.DonId].MAGIAIDOAN;
            dto.qhpl = dto.DonId == null ? null : mapADS_DON[dto.DonId].QUANHEPHAPLUAT_NAME;
            if (dto.NguoiTao != null)
            {
                decimal? idNguoiTao;
                bool isExists = mapUser.TryGetValue(dto.NguoiTao, out idNguoiTao);
                dto.NguoiTaoId = idNguoiTao;
            }

            if (dto.DonId != null)
            {
                dto.biDon = mapDuongSu[dto.DonId]
                    .Where(x => 1 == x.ISDAIDIEN && ENUM_DANSU_TUCACHTOTUNG.BIDON == x.TUCACHTOTUNG_MA)
                    .Select(x => x.TENDUONGSU)
                    .FirstOrDefault();
                dto.nguyenDon = mapDuongSu[dto.DonId]
                    .Where(x => 1 == x.ISDAIDIEN && ENUM_DANSU_TUCACHTOTUNG.NGUYENDON == x.TUCACHTOTUNG_MA)
                    .Select(x => x.TENDUONGSU)
                    .FirstOrDefault();
            }

            // sonnv bo xung thong tin gui sang voffice: so thong bao, ngay thong bao, nguoi ky
            DM_BIEUMAU dM_BIEUMAU = mapBieuMau[entity.BIEUMAUID];
            if (dM_BIEUMAU != null && dM_BIEUMAU.MABM == "29-DS")
            {
                List<AHN_DON_XULY> aDS_DON_XULies = dt.AHN_DON_XULY.Where(x => x.DONID == entity.DONID).ToList();
                if (aDS_DON_XULies != null && aDS_DON_XULies.Any())
                {
                    dto.Sothongbao = Convert.ToString(aDS_DON_XULies[0].SOTHONGBAO);
                    dto.Ngaythongbao = Convert.ToDateTime(aDS_DON_XULies[0].NGAYTHONGBAO);

                }
                // lay thong tin can bo
                decimal? canboid = dt.AHN_DON_THAMPHAN.Where(x => x.DONID == entity.DONID && x.MAVAITRO == "VTTP_GIAIQUYETDON").Select(x => x.CANBOID).Take(1).toNumber();
                dto.Nguoiky = canboid;

            }
            else if (dM_BIEUMAU != null && dM_BIEUMAU.MABM == "30-DS")
            {

                List<AHN_SOTHAM_THULY> aDS_DON_XULies = dt.AHN_SOTHAM_THULY.Where(x => x.DONID == entity.DONID).ToList();
                if (aDS_DON_XULies != null && aDS_DON_XULies.Any())
                {
                    dto.Sothongbao = Convert.ToString(aDS_DON_XULies[0].SOTHONGBAO);
                    dto.Ngaythongbao = Convert.ToDateTime(aDS_DON_XULies[0].NGAYTHONGBAO);

                }
                // lay thong tin can bo
                decimal? canboid = dt.AHN_DON_THAMPHAN.Where(x => x.DONID == entity.DONID && x.MAVAITRO == "VTTP_GIAIQUYETDON").Select(x => x.CANBOID).Take(1).toNumber();
                dto.Nguoiky = canboid;
            }
            else if (dM_BIEUMAU != null && dM_BIEUMAU.MABM == "65-DS")
            {
                List<AHN_PHUCTHAM_THULY> aDS_DON_XULies = dt.AHN_PHUCTHAM_THULY.Where(x => x.DONID == entity.DONID).ToList();
                if (aDS_DON_XULies != null && aDS_DON_XULies.Any())
                {
                    dto.Sothongbao = Convert.ToString(aDS_DON_XULies[0].SOTHONGBAO);
                    dto.Ngaythongbao = Convert.ToDateTime(aDS_DON_XULies[0].NGAYTHONGBAO);
                    dto.Nguoiky = aDS_DON_XULies[0].NGUOIKYID;

                }
            }
            else
            {
                List<AHN_FILE> aDS_FILEs = dt.AHN_FILE.Where(x => x.ID == entity.FILEID).ToList();
                if (aDS_FILEs != null && aDS_FILEs.Any())
                {
                    decimal? maGiaiDoan = aDS_FILEs[0].MAGIAIDOAN;
                    // so tham
                    if (maGiaiDoan != null && maGiaiDoan == 2)
                    {
                        List<AHN_SOTHAM_QUYETDINH> aDS_SOTHAM_QUYETDINHs = dt.AHN_SOTHAM_QUYETDINH.Where(x => x.QUYETDINHID == dM_BIEUMAU.QUYETDINHID && x.DONID == entity.DONID).ToList();
                        if (aDS_SOTHAM_QUYETDINHs != null && aDS_SOTHAM_QUYETDINHs.Any())
                        {
                            dto.Sothongbao = Convert.ToString(aDS_SOTHAM_QUYETDINHs[0].SOQD);
                            dto.Ngaythongbao = Convert.ToDateTime(aDS_SOTHAM_QUYETDINHs[0].NGAYQD);
                            dto.Nguoiky = Convert.ToDecimal(aDS_SOTHAM_QUYETDINHs[0].NGUOIKYID);
                        }
                    }

                    // phuc tham
                    else if (maGiaiDoan != null && maGiaiDoan == 3)
                    {
                        List<AHN_PHUCTHAM_QUYETDINH> aDS_PHUCTHAM_QUYETDINHs = dt.AHN_PHUCTHAM_QUYETDINH.Where(x => x.QUYETDINHID == dM_BIEUMAU.QUYETDINHID && x.DONID == entity.DONID).ToList();
                        if (aDS_PHUCTHAM_QUYETDINHs != null && aDS_PHUCTHAM_QUYETDINHs.Any())
                        {
                            dto.Sothongbao = Convert.ToString(aDS_PHUCTHAM_QUYETDINHs[0].SOQD);
                            dto.Ngaythongbao = Convert.ToDateTime(aDS_PHUCTHAM_QUYETDINHs[0].NGAYQD);
                            dto.Nguoiky = Convert.ToDecimal(aDS_PHUCTHAM_QUYETDINHs[0].NGUOIKYID);
                        }

                    }


                }

            }
            return dto;
        }

        private DoiTuongDTO ToDTO(TongDatDTO entityTongDat, AHN_TONGDAT_DOITUONG entity, AHN_DON_DUONGSU duongSu)
        {
            if (entityTongDat == null || entity == null) return null;

            DoiTuongDTO dto = new DoiTuongDTO();

            dto.MaTuCach = entity.MATUCACH;
            dto.HinhThucGui = entity.HINHTHUCGUI;
            dto.DuongSuId = entity.ID;
            dto.CoQuan = entity.COQUAN;
            dto.NoiDung = entity.NOIDUNG;
            dto.NguoiTao = entityTongDat.NguoiTao;
            dto.NgayTao = entityTongDat.NgayTao;
            dto.NguoiSua = entityTongDat.NguoiSua;
            dto.QuocGia = entity.QUOCGIA;
            dto.PhatHanhLaiId = entity.PHATHANHLAI_ID;

            dto.IsUTTP = entity.IS_UTTP;
            dto.UTTP = entity.UTTP;
            if (duongSu != null)
            {
                dto.TenDuongSu = entity.IS_UTTP == 1 ? entity.NOINHAN : duongSu.TENDUONGSU;
                dto.SoCMND = duongSu.SOCMND;
                dto.QuocTichId = duongSu.QUOCTICHID;
                dto.TinhId = duongSu.TAMTRUTINHID == null ? duongSu.HKTTTINHID : duongSu.TAMTRUTINHID;
                dto.HuyenId = duongSu.TAMTRUID == null ? duongSu.HKTTID : duongSu.TAMTRUID;
                dto.DiaChiChiTiet = entity.IS_UTTP == 1 ? entity.DIACHI : (duongSu.TAMTRUCHITIET == null ? duongSu.HKTTCHITIET : duongSu.TAMTRUCHITIET);
                dto.NamSinh = duongSu.NAMSINH;
                dto.SinhSongNuocNgoai = duongSu.SINHSONG_NUOCNGOAI;
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