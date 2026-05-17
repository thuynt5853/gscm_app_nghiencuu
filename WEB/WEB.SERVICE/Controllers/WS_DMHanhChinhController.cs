using DAL.GSTP;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using WEB.Service.Models;

namespace WEB.Service.Controllers
{
    public class WS_DMHanhChinhController : ApiController
    {
        private GSTPContext dt = new GSTPContext();
        // GET: api/WS_DMHanhChinh
        public IEnumerable<string> Get()
        {
            return new string[] { "value1", "value2" };
        }

        // GET: api/WS_DMHanhChinh/5
        public string Get(int id)
        {
            return "value";
        }

        // POST: api/WS_DMHanhChinh
        public MessageResult Post([FromBody]DMHanhChinhDL value)
        {
            //00: Đồng bộ thành công
            //01: Dữ liệu không đầy đủ
            //02: Mã đơn vị hành chính đã tồn tại
            //03: Tên đơn vị hành chính đã tồn tại
            //04: Lỗi khi đồng bộ
            try
            {
                MessageResult oMsg = new MessageResult();
                string MaDongBo = (value.MaDongBo + "").Trim(), MaHanhChinh = (value.MaHanhChinh + "").Trim(), MaCapCha = (value.MaCapCha + "").Trim(), Ten = (value.Ten + "").Trim();
                #region Valid data
                if (MaDongBo == "" || MaHanhChinh == "" || Ten == "")
                {
                    oMsg.Status = "01";
                    oMsg.Message = "Dữ liệu không đầy đủ. Bạn phải nhập Mã đồng bộ, Mã đơn vị Hành chính, Tên đơn vị Hành chính.";
                    return oMsg;
                }
                DM_HANHCHINH oCheck = dt.DM_HANHCHINH.Where(x => x.MA.ToLower() == MaHanhChinh.ToLower()).FirstOrDefault<DM_HANHCHINH>();
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
                        oMsg.Message = "Mã đơn vị hành chính đã tồn tại";
                        return oMsg;
                    }
                }
                oCheck = dt.DM_HANHCHINH.Where(x => x.TEN.ToLower() == Ten.ToLower()).FirstOrDefault<DM_HANHCHINH>();
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
                        oMsg.Message = "Tên đơn vị hành chính đã tồn tại";
                        return oMsg;
                    }
                }
                string strValid = ValidateForm(MaDongBo, MaCapCha, MaHanhChinh, Ten);
                if (strValid != "")
                {
                    oMsg.Status = "04";
                    oMsg.Message = "Lỗi khi đồng bộ. " + strValid;
                    return oMsg;
                }
                #endregion
                #region Update Data
                bool isNew = false;
                DM_HANHCHINH oHanhChinhCurent = dt.DM_HANHCHINH.Where(x => x.MADONGBO.ToLower() == MaDongBo.ToLower()).FirstOrDefault<DM_HANHCHINH>();
                if (oHanhChinhCurent == null)
                {
                    isNew = true;
                    oHanhChinhCurent = new DM_HANHCHINH();
                    oHanhChinhCurent.THUTU = 1;
                    oHanhChinhCurent.MA = MaHanhChinh.Trim();
                }
                oHanhChinhCurent.MADONGBO = MaDongBo;
                decimal ParentID = 0;
                DM_HANHCHINH HanhChinhParent = null;
                if (MaCapCha == "" || MaCapCha == "0")
                {
                    ParentID = 0;
                }
                else
                {
                    HanhChinhParent = dt.DM_HANHCHINH.Where(x => x.MADONGBO.ToLower() == MaCapCha.ToLower()).FirstOrDefault<DM_HANHCHINH>();
                    if (HanhChinhParent != null)
                    {
                        ParentID = HanhChinhParent.ID;
                    }
                }
                oHanhChinhCurent.CAPCHAID = ParentID;
                oHanhChinhCurent.TEN = Ten.Trim();
                oHanhChinhCurent.LOAI = oHanhChinhCurent.SOCAP = GetLevel(ParentID) + 1;
                oHanhChinhCurent.HIEULUC = 1;

                if (isNew)
                {
                    dt.DM_HANHCHINH.Add(oHanhChinhCurent);
                }
                dt.SaveChanges();
                #region Lưu ArrSapXep và ArrThuTu
                string strArrSapXep = "", strArrThuTu = "", strTen = "";
                HanhChinhParent = dt.DM_HANHCHINH.Where(x => x.ID == ParentID).FirstOrDefault<DM_HANHCHINH>();
                if (HanhChinhParent == null)
                {
                    strTen = oHanhChinhCurent.TEN;
                    strArrSapXep = "0/" + oHanhChinhCurent.ID;
                    if (oHanhChinhCurent.THUTU < 10)
                    {
                        strArrThuTu = "0" + "/" + oHanhChinhCurent.THUTU + "00";
                    }
                    else
                    {
                        strArrThuTu = "0" + "/9" + oHanhChinhCurent.THUTU;
                    }
                }
                else
                {
                    strTen = oHanhChinhCurent.TEN + ", " + HanhChinhParent.MA_TEN;
                    strArrSapXep = HanhChinhParent.ARRSAPXEP + "/" + oHanhChinhCurent.ID;
                    strArrThuTu = HanhChinhParent.ARRTHUTU + "/100";
                    if (oHanhChinhCurent.THUTU < 10)
                    {
                        strArrThuTu = HanhChinhParent.ARRTHUTU + "/" + oHanhChinhCurent.THUTU + "00";
                    }
                    else
                    {
                        strArrThuTu = HanhChinhParent.ARRTHUTU + "/9" + oHanhChinhCurent.THUTU;
                    }
                }
                oHanhChinhCurent.MA_TEN = strTen;
                oHanhChinhCurent.ARRSAPXEP = strArrSapXep;
                oHanhChinhCurent.ARRTHUTU = strArrThuTu;
                dt.SaveChanges();
                #endregion
                // Nếu là sửa thì kiểm tra đơn vị sửa có đơn vị con hay không. Nếu có phải update lại ArrSapXep và ArrThuTu
                if (!isNew)
                {
                    List<DM_HANHCHINH> lst = dt.DM_HANHCHINH.Where(x => x.CAPCHAID == oHanhChinhCurent.ID).ToList();
                    if (lst != null && lst.Count > 0)
                    {
                        UpdateChildren(lst, strArrThuTu, strArrSapXep, oHanhChinhCurent.MA_TEN, (decimal)oHanhChinhCurent.SOCAP);
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
                oMsg.Status = "04";
                oMsg.Message = "Lỗi khi đồng bộ. " + ex.Message;
                return oMsg;
            }
        }

        // PUT: api/WS_DMHanhChinh/5
        public void Put(int id, [FromBody]string value)
        {
        }

        // DELETE: api/WS_DMHanhChinh/5
        public MessageResult Delete(string MaDongBo)
        {
            //05: Xóa thành công
            //06: Có dữ liệu liên quan không được xóa
            //07: Lỗi khi xóa dữ liệu
            try
            {
                MessageResult oMsg = new MessageResult();
                // Kiểm tra đơn vị muốn xóa có dữ liệu liên quan hay không. Nếu có không được xóa.
                string strMaDongBo = (MaDongBo + "").Trim();
                DM_HANHCHINH oHanhChinhDel = dt.DM_HANHCHINH.Where(x => x.MADONGBO.ToLower() == strMaDongBo.ToLower()).FirstOrDefault<DM_HANHCHINH>();
                if (oHanhChinhDel != null)
                {
                    // kiểm tra tại DM_TOAAN
                    DM_TOAAN oToaAn = dt.DM_TOAAN.Where(x => x.HANHCHINHID == oHanhChinhDel.ID).FirstOrDefault<DM_TOAAN>();
                    if (oToaAn != null)
                    {
                        oMsg.Status = "06";
                        oMsg.Message = "Có dữ liệu liên quan không được xóa!";
                        return oMsg;
                    }
                    // còn phải kiểm tra ở nhiều nơi khác nữa. Kiểm tra xong mới có thể xóa
                    dt.DM_HANHCHINH.Remove(oHanhChinhDel);
                    dt.SaveChanges();
                }
                oMsg.Status = "05";
                oMsg.Message = "Xóa thành công!";
                return oMsg;
            }
            catch (Exception ex)
            {
                MessageResult oMsg = new MessageResult();
                oMsg.Status = "07";
                oMsg.Message = "Lỗi khi xóa dữ liệu. " + ex.Message;
                return oMsg;
            }
        }
        private string ValidateForm(string MaDongBo, string MaCapCha, string Ma, string Ten)
        {
            if (Ma.Length > 50)
            {
                return "Mã đơn vị không được quá 50 ký tự!";
            }
            if (Ten.Length > 250)
            {
                return "Tên đơn vị không được quá 250 ký tự!";
            }
            // Đơn vị cấp trên không thể là chính nó hoặc là đơn vị cấp dưới của nó
            if (MaDongBo == MaCapCha)
            {
                return "Đơn vị cấp trên không thể là chính nó";
            }
            if (MaCapCha != "" && MaCapCha != "0")
            {
                DM_HANHCHINH HanhChinh = dt.DM_HANHCHINH.Where(x => x.MADONGBO.ToLower() == MaDongBo.ToLower()).FirstOrDefault<DM_HANHCHINH>();
                if (HanhChinh != null)
                {
                    string arrSapXep = HanhChinh.ARRSAPXEP + "/";
                    DM_HANHCHINH HanhChinhParent = dt.DM_HANHCHINH.Where(x => x.MADONGBO.ToLower() == MaCapCha.ToLower()).FirstOrDefault<DM_HANHCHINH>();
                    if (HanhChinhParent != null)
                    {
                        string pArrSapXep = HanhChinhParent.ARRSAPXEP;
                        if (pArrSapXep.Contains(arrSapXep))
                        {
                            return "Đơn vị cấp trên không thể là đơn vị cấp dưới của nó!";
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
                DM_HANHCHINH dv = dt.DM_HANHCHINH.Where(x => x.ID == dvID).FirstOrDefault<DM_HANHCHINH>();
                if (dv != null)
                {
                    level = (int)dv.SOCAP;
                }
            }
            return level;
        }
        private void UpdateChildren(List<DM_HANHCHINH> lst, string ParrThuTu, string ParrSapXep, string MaTen, decimal SoCap)
        {
            foreach (DM_HANHCHINH item in lst)
            {
                item.MA_TEN = item.TEN + ", " + MaTen;
                item.ARRSAPXEP = ParrSapXep + "/" + item.ID;
                if (item.THUTU < 10)
                {
                    item.ARRTHUTU = ParrThuTu + "/" + item.THUTU + "00";
                }
                else
                {
                    item.ARRTHUTU = ParrThuTu + "/9" + item.THUTU;
                }
                item.LOAI = item.SOCAP = SoCap + 1;
                dt.SaveChanges();
                List<DM_HANHCHINH> lstChild = dt.DM_HANHCHINH.Where(x => x.CAPCHAID == item.ID).ToList();
                if (lstChild != null && lstChild.Count > 0)
                {
                    UpdateChildren(lstChild, item.ARRTHUTU, item.ARRSAPXEP, item.MA_TEN, (decimal)item.SOCAP);
                }
            }
        }
    }
}
