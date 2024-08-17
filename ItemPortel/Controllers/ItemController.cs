using ItemPortel.Models;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ItemPortel.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ItemController : Controller
    {
        public readonly TrainingDBContext trainingDBContext;
        public ItemController(TrainingDBContext _trainingDBContext)
        {
            trainingDBContext = _trainingDBContext;
        }
        [HttpGet("GetItemDetails")]
        public List<Item> GetItemDetails()
        {
            List<Item> lstItem = new List<Item>();
            try
            {
                lstItem = trainingDBContext.Item.ToList();
                return lstItem;
            }
            catch (Exception ex)
            {
                lstItem = new List<Item>();
                return lstItem;
            }
        }
        [HttpPost("AddItem")]
        public string AddItemDetails(Item item)
        {
            string message = string.Empty;
            try
            {
                if (!string.IsNullOrEmpty(item.Description))
                {
                    item.Id = Guid.NewGuid();
                    trainingDBContext.Add(item);
                    trainingDBContext.SaveChanges();
                    message = "Item added successfully";
                }
                else
                    message = "Item description required";
            }
            catch (Exception ex)
            {
                message = ex.Message;
            }
            return message;
        }
    }
}
