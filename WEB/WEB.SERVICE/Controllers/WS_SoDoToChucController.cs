using BL.GSTP;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using WEB.Service.Models;

namespace WEB.Service.Controllers
{
    public class WS_SoDoToChucController : ApiController
    {
        private GSTPContext dt = new GSTPContext();
        // GET: api/WS_SoDoToChuc
        public IEnumerable<string> Get()
        {
            return new string[] { "value1", "value2" };
        }

        // GET: api/WS_SoDoToChuc/5
        public string Get(int id)
        {
            return "value";
        }

        // POST: api/WS_SoDoToChuc
        public MessageResult Post([FromBody]DMToaAnDL value)
        {
            //00: Đồng bộ thành công
            //01: Dữ liệu không đầy đủ
            //02: Mã tòa án đã tồn tại
            //03: Tên tòa án đã tồn tại
            //04: Loại tòa án không tồn tại
            //05: Mã hành chính không tồn tại
            //06: Lỗi khi đồng bộ

            try
            {
                MessageResult oMsg = new MessageResult();
                string MaDongBo = (value.MaDongBo + "").Trim(), MaToaAn = (value.MaToaAn + "").Trim(), MaCapCha = (value.MaCapCha + "").Trim(),
                    Ten = (value.Ten + "").Trim(), LoaiToa = (value.LoaiToa + "").Trim(), MaHanhChinh = (value.MaHanhChinh + "").Trim();
                #region Valid data
                if (MaDongBo == "" || MaToaAn == "" || Ten == "" || LoaiToa == "")
                {
                    oMsg.Status = "01";
                    oMsg.Message = "Dữ liệu không đầy đủ. Bạn cần phải nhập Mã đồng bộ, Mã Tòa án, Tên tòa án, Loại Tòa án.";
                    return oMsg;
                }
                DM_TOAAN oCheck = dt.DM_TOAAN.Where(x => x.MA.ToLower() == MaToaAn.ToLower()).FirstOrDefault<DM_TOAAN>();
                if (oCheck != null)
                {
                    // nếu oCheck.MADONGBO là Null hoặc Empty thì thì gán luôn
                    if ((oCheck.MADONGBO + "") == "")
                    {
                        oCheck.MADONGBO = MaDongBo;
                        dt.SaveChanges();
                    }
                    if (oCheck.MADONGBO != MaDongBo)
                    {
                        oMsg.Status = "02";
                        oMsg.Message = "Mã tòa án đã tồn tại";
                        return oMsg;
                    }
                }
                oCheck = dt.DM_TOAAN.Where(x => x.TEN.ToLower() == Ten.ToLower()).FirstOrDefault<DM_TOAAN>();
                if (oCheck != null)
                {
                    // nếu oCheck.MADONGBO là Null hoặc Empty thì gán luôn
                    if ((oCheck.MADONGBO + "") == "")
                    {
                        oCheck.MADONGBO = MaDongBo;
                        dt.SaveChanges();
                    }
                    if (oCheck.MADONGBO != MaDongBo)
                    {
                        oMsg.Status = "03";
                        oMsg.Message = "Tên tòa án đã tồn tại";
                        return oMsg;
                    }
                }
                string listLoaiToaAn = "";
                DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
                DataTable dmLoaiToaAn = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.LOAITOA);
                if (dmLoaiToaAn != null && dmLoaiToaAn.Rows.Count > 0)
                {
                    foreach (DataRow row in dmLoaiToaAn.Rows)
                    {
                        listLoaiToaAn += listLoaiToaAn + "," + row["MA"].ToString();
                    }
                    if (!listLoaiToaAn.Contains(LoaiToa))
                    {
                        oMsg.Status = "04";
                        oMsg.Message = "Loại tòa án phải là: TOICAO (TAND Tối cao), CAPCAO (TAND Cấp cao), CAPTINH (TAND tỉnh, thành phố trực thuộc trung ương), CAPHUYEN (TAND huyện, quận, thị xã, thành phố thuộc tỉnh), QSTRUNGUONG (Tòa án quân sự trung ương), QSQUANKHU (Tòa án quân sự quân khu và tương đương), QSKHUVUC (Tòa án quân sự khu vực)";
                        return oMsg;
                    }
                }
                decimal HanhChinhID = 0;
                if (MaHanhChinh != "")
                {
                    DM_HANHCHINH oHanhChinh = dt.DM_HANHCHINH.Where(x => x.MADONGBO.ToLower() == MaHanhChinh.ToLower()).FirstOrDefault<DM_HANHCHINH>();
                    if (oHanhChinh == null)
                    {
                        oMsg.Status = "05";
                        oMsg.Message = "Mã hành chính không tồn tại";
                        return oMsg;
                    }
                    else
                    {
                        HanhChinhID = oHanhChinh.ID;
                    }
                }
                string DiaChi = (value.DiaChi + "").Trim(), DienThoai = (value.DienThoai + "").Trim(), Fax = (value.Fax + "").Trim(), Email = (value.Email + "").Trim();
                string strValid = ValidateForm(MaDongBo, MaCapCha, MaToaAn, Ten, DiaChi, DienThoai, Fax, Email);
                if (strValid != "")
                {
                    oMsg.Status = "06";
                    oMsg.Message = "Lỗi khi đồng bộ. " + strValid;
                    return oMsg;
                }
                #endregion
                #region Update Data
                bool isNew = false;
                DM_TOAAN oToaAnCurent = dt.DM_TOAAN.Where(x => x.MADONGBO.ToLower() == MaDongBo.ToLower()).FirstOrDefault<DM_TOAAN>();
                if (oToaAnCurent == null)
                {
                    isNew = true;
                    oToaAnCurent = new DM_TOAAN();
                    oToaAnCurent.THUTU = 1;
                    oToaAnCurent.MA = MaToaAn.Trim();
                }
                oToaAnCurent.MADONGBO = MaDongBo;
                decimal ParentID = 0;
                DM_TOAAN ToaAnParent = null;
                if (MaCapCha == "" || MaCapCha == "0")
                {
                    ParentID = 0;
                }
                else
                {
                    ToaAnParent = dt.DM_TOAAN.Where(x => x.MADONGBO.ToLower() == MaCapCha.ToLower()).FirstOrDefault<DM_TOAAN>();
                    if (ToaAnParent != null)
                    {
                        ParentID = ToaAnParent.ID;
                    }
                    else
                    {
                        oMsg.Status = "06";
                        oMsg.Message = "Lỗi khi đồng bộ. " + "Không tìm thấy tòa cấp trên.";
                        return oMsg;
                    }
                }
                oToaAnCurent.CAPCHAID = ParentID;
                oToaAnCurent.TEN = Ten.Trim();
                oToaAnCurent.LOAITOA = LoaiToa;
                oToaAnCurent.HANHCHINHID = HanhChinhID;
                oToaAnCurent.DIACHI = DiaChi;
                oToaAnCurent.DIENTHOAI = DienThoai;
                oToaAnCurent.FAX = Fax;
                oToaAnCurent.EMAIL = Email;
                oToaAnCurent.SOCAP = GetLevel(ParentID) + 1;
                oToaAnCurent.HIEULUC = 1;
                oToaAnCurent.THUTU = 1;
                if (isNew)
                {
                    dt.DM_TOAAN.Add(oToaAnCurent);
                }
                dt.SaveChanges();
                #region Lưu ArrSapXep và ArrThuTu
                string strArrSapXep = "", strArrThuTu = "", strTen = "";
                ToaAnParent = dt.DM_TOAAN.Where(x => x.ID == ParentID).FirstOrDefault<DM_TOAAN>();
                if (ToaAnParent == null)
                {
                    strTen = oToaAnCurent.TEN;
                    strArrSapXep = "0/" + oToaAnCurent.ID;
                    if (oToaAnCurent.THUTU < 10)
                    {
                        strArrThuTu = "0" + "/" + oToaAnCurent.THUTU + "00";
                    }
                    else
                    {
                        strArrThuTu = "0" + "/9" + oToaAnCurent.THUTU;
                    }
                }
                else
                {
                    strArrSapXep = ToaAnParent.ARRSAPXEP + "/" + oToaAnCurent.ID;
                    if (oToaAnCurent.THUTU < 10)
                    {
                        strArrThuTu = ToaAnParent.ARRTHUTU + "/" + oToaAnCurent.THUTU + "00";
                    }
                    else
                    {
                        strArrThuTu = ToaAnParent.ARRTHUTU + "/9" + oToaAnCurent.THUTU;
                    }
                    strTen = oToaAnCurent.TEN + " - " + ToaAnParent.TEN;
                }
                oToaAnCurent.MA_TEN = strTen;
                oToaAnCurent.ARRSAPXEP = strArrSapXep; oToaAnCurent.ARRTHUTU = strArrThuTu;
                dt.SaveChanges();
                #endregion
                // Nếu là sửa thì kiểm tra đơn vị sửa có đơn vị con hay không. Nếu có phải update lại ArrSapXep và ArrThuTu
                if (!isNew)
                {
                    List<DM_TOAAN> lst = dt.DM_TOAAN.Where(x => x.CAPCHAID == oToaAnCurent.ID).ToList();
                    if (lst != null && lst.Count > 0)
                    {
                        UpdateChildren(lst, strArrThuTu, strArrSapXep, oToaAnCurent.MA_TEN, (decimal)oToaAnCurent.SOCAP);
                    }
                }
                #endregion
                oMsg.Status = "00";
                oMsg.Message = "Đồng bộ thành công";
                return oMsg;
            }
            catch (Exception ex)
            {
                MessageResult oMsg = new MessageResult();
                oMsg.Status = "06";
                oMsg.Message = "Lỗi khi đồng bộ. " + ex.Message;
                return oMsg;
            }
        }

        // PUT: api/WS_SoDoToChuc/5
        public void Put(int id, [FromBody]string value)
        {
        }

        // DELETE: api/WS_SoDoToChuc/5
        public MessageResult Delete(string MaDongBo)
        {
            //07: Xóa thành công
            //08: Có dữ liệu liên quan không được xóa
            //09: Lỗi khi xóa dữ liệu
            try
            {
                MessageResult oMsg = new MessageResult();
                // Kiểm tra đơn vị muốn xóa có dữ liệu liên quan hay không. Nếu có không được xóa.
                string strMaDongBo = (MaDongBo + "").Trim();
                DM_TOAAN oToaAnDel = dt.DM_TOAAN.Where(x => x.MADONGBO == strMaDongBo).FirstOrDefault<DM_TOAAN>();
                if (oToaAnDel != null)
                {
                    ADS_DON oADS_Don = dt.ADS_DON.Where(x => x.TOAANID == oToaAnDel.ID).FirstOrDefault<ADS_DON>();
                    if (oADS_Don != null)
                    {
                        oMsg.Status = "08";
                        oMsg.Message = " Có dữ liệu liên quan không được xóa!";
                        return oMsg;
                    }
                    AHC_DON oAHC_Don = dt.AHC_DON.Where(x => x.TOAANID == oToaAnDel.ID).FirstOrDefault<AHC_DON>();
                    if (oAHC_Don != null)
                    {
                        oMsg.Status = "08";
                        oMsg.Message = " Có dữ liệu liên quan không được xóa!";
                        return oMsg;
                    }
                    AHN_DON oAHN_Don = dt.AHN_DON.Where(x => x.TOAANID == oToaAnDel.ID).FirstOrDefault<AHN_DON>();
                    if (oAHN_Don != null)
                    {
                        oMsg.Status = "08";
                        oMsg.Message = " Có dữ liệu liên quan không được xóa!";
                        return oMsg;
                    }
                    AHS_VUAN oAHS_VuAn = dt.AHS_VUAN.Where(x => x.TOAANID == oToaAnDel.ID).FirstOrDefault<AHS_VUAN>();
                    if (oAHS_VuAn != null)
                    {
                        oMsg.Status = "08";
                        oMsg.Message = " Có dữ liệu liên quan không được xóa!";
                        return oMsg;
                    }
                    AKT_DON oAKT_Don = dt.AKT_DON.Where(x => x.TOAANID == oToaAnDel.ID).FirstOrDefault<AKT_DON>();
                    if (oAKT_Don != null)
                    {
                        oMsg.Status = "08";
                        oMsg.Message = " Có dữ liệu liên quan không được xóa!";
                        return oMsg;
                    }
                    ALD_DON oALD_Don = dt.ALD_DON.Where(x => x.TOAANID == oToaAnDel.ID).FirstOrDefault<ALD_DON>();
                    if (oALD_Don != null)
                    {
                        oMsg.Status = "08";
                        oMsg.Message = " Có dữ liệu liên quan không được xóa!";
                        return oMsg;
                    }
                    APS_DON oAPS_Don = dt.APS_DON.Where(x => x.TOAANID == oToaAnDel.ID).FirstOrDefault<APS_DON>();
                    if (oAPS_Don != null)
                    {
                        oMsg.Status = "08";
                        oMsg.Message = " Có dữ liệu liên quan không được xóa!";
                        return oMsg;
                    }
                    XLHC_DON oXLHC_Don = dt.XLHC_DON.Where(x => x.TOAANID == oToaAnDel.ID).FirstOrDefault<XLHC_DON>();
                    if (oXLHC_Don != null)
                    {
                        oMsg.Status = "08";
                        oMsg.Message = " Có dữ liệu liên quan không được xóa!";
                        return oMsg;
                    }
                    dt.DM_TOAAN.Remove(oToaAnDel);
                    dt.SaveChanges();
                }
                oMsg.Status = "07";
                oMsg.Message = "Xóa thành công!";
                return oMsg;
            }
            catch (Exception ex)
            {
                MessageResult oMsg = new MessageResult();
                oMsg.Status = "09";
                oMsg.Message = "Lỗi khi xóa dữ liệu. " + ex.Message;
                return oMsg;
            }
        }
        private string ValidateForm(string MaDongBo, string MaCapCha, string Ma, string Ten, string DiaChi, string DienThoai, string Fax, string Email)
        {
            if (Ma.Length > 50)
            {
                return "Mã tòa án không được quá 50 ký tự!";
            }
            if (Ten.Length > 250)
            {
                return "Tên tòa án không được quá 250 ký tự!";
            }
            if (DiaChi.Length > 250)
            {
                return "Địa chỉ tòa án không được quá 250 ký tự!";
            }
            if (Fax.Length > 150)
            {
                return "Số Fax của tòa án không được quá 150 ký tự!";
            }
            if (Email.Length > 150)
            {
                return "Email của tòa án không được quá 150 ký tự!";
            }
            // Đơn vị cấp trên không thể là chính nó hoặc là đơn vị cấp dưới của nó
            if (MaDongBo == MaCapCha)
            {
                return "Tòa án cấp trên không thể là chính nó";
            }
            if (MaCapCha != "" && MaCapCha != "0")
            {
                DM_TOAAN ToaAn = dt.DM_TOAAN.Where(x => x.MADONGBO.ToLower() == MaDongBo.ToLower()).FirstOrDefault<DM_TOAAN>();
                if (ToaAn != null)
                {
                    string arrSapXep = ToaAn.ARRSAPXEP + "/";
                    DM_TOAAN ToaAnParent = dt.DM_TOAAN.Where(x => x.MADONGBO.ToLower() == MaCapCha.ToLower()).FirstOrDefault<DM_TOAAN>();
                    if (ToaAnParent != null)
                    {
                        string pArrSapXep = ToaAnParent.ARRSAPXEP;
                        if (pArrSapXep.Contains(arrSapXep))
                        {
                            return "Tòa án cấp trên không thể là tòa án cấp dưới của nó!";
                        }
                    }
                }
            }
            return "";
        }
        private int GetLevel(decimal dvID)
        {
            int level = 0;
            if (dvID == 0)
            {
                level = 0;
            }
            else
            {
                DM_TOAAN dv = dt.DM_TOAAN.Where(x => x.ID == dvID).FirstOrDefault<DM_TOAAN>();
                if (dv != null)
                {
                    level = (int)dv.SOCAP;
                }
            }
            return level;
        }
        private void UpdateChildren(List<DM_TOAAN> lst, string ParrThuTu, string ParrSapXep, string MaTen, decimal SoCap)
        {
            string Ten = MaTen;
            if (MaTen.Contains("-"))
            {
                string[] arrStr = MaTen.Split('-');
                Ten = arrStr[0].ToString().Trim();
            }
            foreach (DM_TOAAN item in lst)
            {
                item.MA_TEN = item.TEN + " - " + Ten;
                item.ARRSAPXEP = ParrSapXep + "/" + item.ID;
                if (item.THUTU < 10)
                {
                    item.ARRTHUTU = ParrThuTu + "/" + item.THUTU + "00";
                }
                else
                {
                    item.ARRTHUTU = ParrThuTu + "/9" + item.THUTU;
                }
                item.SOCAP = SoCap + 1;
                dt.SaveChanges();
                List<DM_TOAAN> lstChild = dt.DM_TOAAN.Where(x => x.CAPCHAID == item.ID).ToList();
                if (lstChild != null && lstChild.Count > 0)
                {
                    UpdateChildren(lstChild, item.ARRTHUTU, item.ARRSAPXEP, item.MA_TEN, Convert.ToInt32(item.SOCAP));
                }
            }
        }
    }
}
