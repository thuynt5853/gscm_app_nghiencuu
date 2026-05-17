<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/DONKK.Master" AutoEventWireup="true" CodeBehind="LienHe.aspx.cs" Inherits="WEB.DONKHOIKIEN.LienHe" %>

<%@ Register Src="~/UserControl/Home_HuongDan.ascx" TagPrefix="uc1" TagName="Home_HuongDan" %>
<%@ Register Src="~/UserControl/Home_ThongBao.ascx" TagPrefix="uc1" TagName="Home_ThongBao" %>
<%@ Register Src="~/UserControl/HuongDan.ascx" TagPrefix="uc1" TagName="HuongDan" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style type="text/css">
        .guidonkien_head {
            display: none;
        }
    </style>
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageSize" Value="20" runat="server" />
    <div class="content_center">
        <div class="content_form">
            <div class="hosoleft">
                <uc1:HuongDan runat="server" ID="HuongDan" />
            </div>

            <div class="hosoright">
                <div class="thongtin_lienhe" style="box-shadow: 0 3px 7px rgba(0, 0, 0, 0.2);">
                    <div class="dangky_head border_radius_top">
                        <div class="dangky_head_title">Thông tin liên hệ</div>
                        <div class="dangky_head_right"></div>
                    </div>
                    <div class="dangky_content">
                        <span style="float: left; margin-right:10px;">
                            <span style="float: left; line-height: 25px;margin-right:5px;">Tòa án</span>
                            
                            <span style="float: left;">
                                <asp:HiddenField ID="hddToaAnID" runat="server" />
                                <asp:TextBox ID="txtToaAn" CssClass="dangky_tk_textbox" runat="server" Width="250px"
                                    MaxLength="300" AutoCompleteType="Search"></asp:TextBox></span>
                        </span>
                        <asp:Button ID="cmdSearch" runat="server" CssClass="button_search"
                            Text="Tìm kiếm" OnClick="cmdSearch_Click" />

                        <i style="float: left; width: 100%; font-weight: normal; margin-top: 10px;">(Gõ tên Tòa án vào ô trên để tìm kiếm và lựa chọn Tòa án cần xem thông tin liên hệ)</i>
                        <div style="float: left; width: 100%;">
                            <asp:Literal ID="lbthongbao" runat="server"></asp:Literal>
                        </div>
                        <asp:Panel ID="pnPaging1" runat="server">
                            <div class="phantrang">
                                <div class="sobanghi">
                                    <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
                                </div>
                                <div class="sotrang">
                                    <asp:LinkButton ID="lbTBack" runat="server" CausesValidation="false" CssClass="back"
                                        OnClick="lbTBack_Click" Text="<"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTFirst" runat="server" CausesValidation="false" CssClass="active"
                                        Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                    <asp:Label ID="lbTStep1" runat="server" Text="..."></asp:Label>
                                    <asp:LinkButton ID="lbTStep2" runat="server" CausesValidation="false" CssClass="so"
                                        Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTStep3" runat="server" CausesValidation="false" CssClass="so"
                                        Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTStep4" runat="server" CausesValidation="false" CssClass="so"
                                        Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTStep5" runat="server" CausesValidation="false" CssClass="so"
                                        Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:Label ID="lbTStep6" runat="server" Text="..."></asp:Label>
                                    <asp:LinkButton ID="lbTLast" runat="server" CausesValidation="false" CssClass="so"
                                        Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTNext" runat="server" CausesValidation="false" CssClass="next"
                                        OnClick="lbTNext_Click" Text=">"></asp:LinkButton>
                                </div>
                            </div>
                        </asp:Panel>

                        <div class="CSSTableGenerator">
                            <table>
                                <tr id="row_header">
                                    <td style="width: 20px;">TT</td>
                                    <td  style="width: 35%;">Tên Tòa án</td>
                                    <td>Địa chỉ</td>
                                    <td style="width: 100px;">Điện thoại</td>
                                </tr>
                                <asp:Repeater ID="rpt" runat="server">
                                    <ItemTemplate>
                                        <tr>
                                            <td><%#Eval("STT") %></td>
                                            <td>
                                                <div style="text-align: justify; float: left;">
                                                    <%#Eval("TEN") %>
                                                </div>
                                            </td>
                                            <td><%#Eval("Diachi")%></td>
                                            <td><%#Eval("DienThoai")%></td>
                                        </tr>
                                    </ItemTemplate>

                                </asp:Repeater>
                            </table>
                        </div>
                        <asp:Panel ID="pnPaging2" runat="server">
                            <div class="phantrang">
                                <div class="sobanghi">
                                    <asp:HiddenField ID="hdicha" runat="server" />
                                    <asp:Literal ID="lstSobanghiB" runat="server"></asp:Literal>
                                </div>
                                <div class="sotrang">
                                    <asp:LinkButton ID="lbBBack" runat="server" CausesValidation="false" CssClass="back"
                                        OnClick="lbTBack_Click" Text="<"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBFirst" runat="server" CausesValidation="false" CssClass="active"
                                        Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                    <asp:Label ID="lbBStep1" runat="server" Text="..."></asp:Label>
                                    <asp:LinkButton ID="lbBStep2" runat="server" CausesValidation="false" CssClass="so"
                                        Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBStep3" runat="server" CausesValidation="false" CssClass="so"
                                        Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBStep4" runat="server" CausesValidation="false" CssClass="so"
                                        Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBStep5" runat="server" CausesValidation="false" CssClass="so"
                                        Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:Label ID="lbBStep6" runat="server" Text="..."></asp:Label>
                                    <asp:LinkButton ID="lbBLast" runat="server" CausesValidation="false" CssClass="so"
                                        Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBNext" runat="server" CausesValidation="false" CssClass="next"
                                        OnClick="lbTNext_Click" Text=">"></asp:LinkButton>
                                </div>
                            </div>
                        </asp:Panel>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!------------------------------------->
    <uc1:Home_HuongDan runat="server" ID="Home_HuongDan" />
    <!------------------------------------->
    <div class="content_info_main">
        <uc1:Home_ThongBao runat="server" ID="Home_ThongBao" />
    </div>

    <script>
        function pageLoad(sender, args) {
            $(function () {
                var urldm_toaan = '<%=ResolveUrl("~/Ajax/SearchDanhmuc.aspx/SearchTopToaAn") %>';
                $("[id$=txtToaAn]").autocomplete({
                    source: function (request, response) {
                        $.ajax({
                            url: urldm_toaan, data: "{ 'textsearch': '" + request.term + "'}", dataType: "json", type: "POST", contentType: "application/json; charset=utf-8",
                            success: function (data) { response($.map(data.d, function (item) { return { label: item.split('_')[1], val: item.split('_')[0] } })) }, error: function (response) { }, failure: function (response) { }
                        });
                    },
                    select: function (e, i) {
                        $("[id$=hddToaAnID]").val(i.item.val);
                    }, minLength: 1
                });
            });
        }
    </script>
    <script type="text/javascript">
        $(document).ready(function () {
            $('input[type=text]').on('keypress', function (e) {
                if (e.which == 13)
                    $("#<%= cmdSearch.ClientID %>").click();
            });
        });
    </script>
</asp:Content>
